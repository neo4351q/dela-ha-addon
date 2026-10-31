// Патч для аддона Dela: добавляет логирование ВСЕХ ошибок сервера (не только 500).
// После применения в логе аддона появятся строки вида:
//   [Dela error] 429 rate_limited слишком много попыток — подождите 15 минут или перезапустите аддон
'use strict';

const fs = require('fs');

const file = '/app/apps/server/src/app.ts';
const source = fs.readFileSync(file, 'utf8');
const needle = 'throw new HTTPException(status, {';
const marker = '[Dela error]';

if (source.includes(marker)) {
  console.log('Dela: логирование ошибок уже добавлено');
  process.exit(0);
}

if (!source.includes(needle)) {
  console.error('Dela: не найдено место для патча в app.ts');
  process.exit(1);
}

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
  '  ' + needle,
].join('\n');

fs.writeFileSync(file, source.replace(needle, injected));
console.log('Dela: логирование ошибок добавлено');
