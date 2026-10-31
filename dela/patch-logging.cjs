// Патчи для аддона Dela: логирование ошибок и всех HTTP-запросов в лог аддона.
'use strict';

const fs = require('fs');

// --- Патч 1: логирование всех ошибок (app.ts) ---
const appFile = '/app/apps/server/src/app.ts';
let appSource = fs.readFileSync(appFile, 'utf8');
const appNeedle = 'throw new HTTPException(status, {';

if (appSource.includes('[Dela error]')) {
  console.log('Dela: логирование ошибок уже добавлено');
} else if (!appSource.includes(appNeedle)) {
  console.error('Dela: не найдено место для патча ошибок в app.ts');
  process.exit(1);
} else {
  const injected = [
    '  const DELA_ERRORS = {',
    '    rate_limited: "слишком много попыток — подождите 15 минут или перезапустите аддон",',
    '    registration_closed: "email не совпадает с admin_email в настройках аддона",',
    '    email_taken: "этот email уже зарегистрирован",',
    '    invite_required: "регистрация только по приглашению (первый аккаунт уже создан)",',
    '    invalid_invite: "неверное или просроченное приглашение",',
    '    invalid_credentials: "неверный email или пароль",',
    '    totp_required: "требуется код двухфакторной аутентификации",',
    '    invalid_totp: "неверный код двухфакторной аутентификации",',
    '  };',
    '  console.error("[Dela error]", status, message, DELA_ERRORS[message] || "");',
    '  ' + appNeedle,
  ].join('\n');
  fs.writeFileSync(appFile, appSource.replace(appNeedle, injected));
  console.log('Dela: логирование ошибок добавлено');
}

// --- Патч 2: логирование всех HTTP-запросов (main.ts) ---
const mainFile = '/app/apps/server/src/main.ts';
let mainSource = fs.readFileSync(mainFile, 'utf8');
const mainNeedle = 'const server = serve({ fetch: app.fetch,';

if (mainSource.includes('[Dela req]')) {
  console.log('Dela: логирование запросов уже добавлено');
} else if (!mainSource.includes(mainNeedle)) {
  console.error('Dela: не найдено место для патча запросов в main.ts');
  process.exit(1);
} else {
  const wrapper = [
    'const fetchLogged = (request, ...rest) => {',
    '  const result = app.fetch(request, ...rest);',
    '  result.then((res) => console.error("[Dela req]", request.method, new URL(request.url).pathname, res.status)).catch((err) => console.error("[Dela req]", request.method, new URL(request.url).pathname, "ERR", err));',
    '  return result;',
    '};',
    'const server = serve({ fetch: fetchLogged,',
  ].join('\n');
  fs.writeFileSync(mainFile, mainSource.replace(mainNeedle, wrapper));
  console.log('Dela: логирование запросов добавлено');
}

// --- Патч 3: логирование WebSocket-авторизации (app.ts) ---
let wsSource = fs.readFileSync(appFile, 'utf8');
const wsFailNeedle = 'ws.close(4001, \'unauthorized\');';
const wsOkNeedle = 'hub.add(auth.userId, auth.deviceId, ws);';

if (wsSource.includes('[Dela ws]')) {
  console.log('Dela: логирование WebSocket уже добавлено');
} else if (!wsSource.includes(wsFailNeedle) || !wsSource.includes(wsOkNeedle)) {
  console.error('Dela: не найдено место для патча WebSocket в app.ts');
  process.exit(1);
} else {
  wsSource = wsSource.replace(wsFailNeedle, 'console.error(\'[Dela ws] auth failed\');\n        ' + wsFailNeedle);
  wsSource = wsSource.replace(wsOkNeedle, 'console.error(\'[Dela ws] auth ok\', auth.userId);\n      ' + wsOkNeedle);
  fs.writeFileSync(appFile, wsSource);
  console.log('Dela: логирование WebSocket добавлено');
}
