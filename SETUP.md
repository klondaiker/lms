# Базовый сетап для курса AI driven development

Основное взаимодействие с окружающей системой происходит через CLI-утилиты. Поэтому важно иметь рабочий базовый набор инструментов и agent skills, а после установки проверить, что они не только поставились, но и реально настроены под ваши аккаунты.

Этот файл — каноническая bootstrap-инструкция для самого `ai-setup` и для учебных проектов, созданных как fork на его основе. В downstream-документах ссылайтесь на этот файл, а не копируйте команды `make`, login-шаги, `direnv allow` и `make check`.

## Автоматическая установка

Подходит для базовых Linux-дистрибутивов (Ubuntu-tested) и macOS.

```bash
make
```

По умолчанию `make` запускает target `ai`, который последовательно:

1. ставит `mise`, если его еще нет;
2. устанавливает инструменты из `mise.toml`;
3. ставит CLI-агенты;
4. ставит CLI-утилиты для агентов;
5. ставит curated skills для `codex` и `claude-code`.

## Авторизация

После `make` нужно пройти авторизацию в обязательных сервисах — без этого `make check` упадёт на проверке авторизации:

```bash
claude auth login
codex login
gh auth login
```

Затем настройте интеграцию `direnv` с вашей shell (см. [раздел direnv](#direnv) ниже) и разрешите `.envrc`:

```bash
direnv allow
```

`tgcli`, `googleworkspace/cli`, `himalaya` и связанные Claude plugins/skills — опциональные. Базовый `make check` их не проверяет.

Если нужны эти интеграции, установите их отдельно:

```bash
make extra
```

И проверьте отдельно:

```bash
make extra-check
```

## Проверка установки

После авторизации прогоните базовую проверку окружения:

```bash
make check
```

`make check` проверяет:

- обязательный toolchain из локального setup;
- установку agent CLI;
- обязательные проверки авторизации для `claude`, `codex` и `gh`;
- установку вспомогательных CLI для агентов: `playwright-cli`, `ccbox`;
- базовый shell/env setup, включая `direnv` и числовой `PORT`.

Команда завершается с ошибкой только на проблемах базовой установки.

Дополнительные проверки вынесены отдельно:

- `make extra-check` — опциональные интеграции и Claude plugins/skills;
- `make check-context` — baseline-контекст Claude Code и Codex.

## Что устанавливается автоматически

### Инструменты через `mise`

Из `mise.toml` ставятся: `direnv`, `gh`, `gitleaks`, `jq`, `node`, `port-selector`, `ruby`, `tmux`, `yarn`, `zellij`.

### Кодинговые агенты

- `@anthropic-ai/claude-code`
- `@openai/codex`

### CLI-утилиты для агентов

Обязательные:

| Утилита | Для чего | Как проверить |
| --- | --- | --- |
| [@playwright/cli](https://github.com/microsoft/playwright-cli) | Автоматизация работы с сайтами и тестирование веба | Попросить агента зайти на сайт и сделать скриншот |
| [gh](https://github.com/cli/cli) | Работа с GitHub API за пределами `git`: просмотр и создание issue, pull request, projects | Попросить агента посмотреть или создать issue в репозитории |
| [port-selector](https://github.com/dapi/port-selector) | Автоматический выбор свободного порта из диапазона для локальных dev-серверов и e2e при параллельной работе агентов | Выполнить `port-selector` и убедиться, что команда возвращает номер свободного порта |
| [ccbox](https://github.com/diskd-ai/ccbox) | Инспекция и анализ кодовой базы для агентов | Выполнить `ccbox --version` |

Опциональные (ставятся через `make extra`, alias: `make extra-skills`):

| Утилита | Для чего | Как проверить |
| --- | --- | --- |
| [tgcli](https://github.com/dapi/tgcli) | Сбор требований из переписки | Попросить агента найти что-то в личной переписке в Telegram или закинуть пост в Избранное |
| [googleworkspace/cli](https://github.com/googleworkspace/cli) (`gws-docs`, `gws-docs-write`, `gws-drive`, `gws-sheets`) | Сбор требований и формирование проектной документации | Дать агенту ссылку на закрытый Google Doc и попросить прочитать его и дать выдержку |
| [himalaya](https://github.com/pimalaya/himalaya) | Работа с почтой через IMAP/SMTP из CLI | Попросить агента прочитать письмо или найти письмо по теме после настройки почтового аккаунта |

`make extra-check` покажет `WARN` для этих утилит, если они не установлены или не настроены, но не завершится ошибкой.

Что не ставится автоматически, но желательно поставить:

Методы трекинга задачи и хранения документов зависят от конкретной компании или сценария и должны ставиться отдельно, если они вам нужны:

| Утилита | Для чего | Как проверить |
| --- | --- | --- |
| [jira-cli](https://github.com/ankitpokhrel/jira-cli) | Работа с Jira | Попросить агента прочитать или создать issue |
| [linear-cli](https://github.com/schpet/linear-cli) | Работа с Linear | Попросить агента прочитать или создать issue |
| [trello-cli](https://github.com/mheap/trello-cli) | Работа с Trello | Попросить агента прочитать или создать карточку |

### Skills для агентов

Эти skills ставятся для `codex` и `claude-code`:

`playwright-cli`, `prompt-engeneering`, `ccbox`, `ccbox-insights`.

Через `make extra` дополнительно: `tgcli`, `gws-docs`, `gws-docs-write`, `gws-drive`, `gws-sheets`.

### Plugins для Claude Code

Через `make extra` добавляются marketplace:

- `dapi/claude-code-marketplace`

И ставятся plugins:

`himalaya@dapi`, `pr-review-fix-loop@dapi`, `spec-reviewer@dapi`, `zellij-workflow@dapi`.

Если нужно ставить Claude plugins из вашего marketplace, это можно переопределить при запуске `make`, например:

```bash
make extra \
  CLAUDE_PLUGINS_MARKETPLACES=your-org/claude-code-marketplace \
  CLAUDE_MARKETPLACE_NAMES=your-org \
  CLAUDE_PLUGIN_NAMESPACE=your-org \
  CLAUDE_PLUGINS='zellij-workflow@your-org'
```

## Опциональные интеграции

Установка инструмента, skill или plugin ещё не означает, что агент уже сможет работать с конкретной системой. После настройки обязательной авторизации при необходимости подключите:

- `tgcli`: подключить Telegram-аккаунт
- `googleworkspace/cli`: подключить Google Workspace
- `himalaya`: настроить почтовый аккаунт и доступ к IMAP/SMTP

После настройки аккаунтов повторно запустите `make extra-check`, чтобы убедиться, что `WARN`-статусы для нужных вам интеграций ушли.

## Что сохранить в производном проекте

Если вы создаете учебный проект на основе этого репозитория, исходный `README.md` предполагается заменить README вашего проекта.

Чтобы вместе с этим не потерять onboarding по окружению, сохраните требования к локальному setup в отдельном постоянном документе производного репозитория:

- `SETUP.md`, если хотите держать setup отдельно от README;
- `CONTRIBUTING.md`, если это часть developer onboarding;
- `docs/onboarding.md`, если нужна более подробная внутренняя документация.

Минимум, который стоит сохранить в таком документе:

- как поднять локальное окружение;
- как пройти обязательную авторизацию для CLI;
- как проверить результат через `make check`.

## direnv

В проекте используется `direnv`:

1. настройте интеграцию с вашей shell: [direnv hooks documentation](https://direnv.net/docs/hook.html)
2. разрешите локальный `.envrc` в корне проекта:

```bash
direnv allow
```

`.envrc` подхватывает `.env` и `.env.local`, а если `PORT` не задан явно, выставляет его автоматически через `port-selector`. `make check` проверяет, что `direnv` действительно экспортирует числовой `PORT`.
