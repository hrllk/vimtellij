-- -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
-- local config = {
--   cmd = {
--
--     -- 💀
--     'java',             -- or '/path/to/java21_or_newer/bin/java'
--     -- depends on if `java` is in your $PATH env variable and if it points to the right version.
--
--     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
--     '-Dosgi.bundles.defaultStartLevel=4',
--     '-Declipse.product=org.eclipse.jdt.ls.core.product',
--     '-Dlog.protocol=true',
--     '-Dlog.level=ALL',
--     '-Xmx3g',
--     '-javaagent:' .. vim.fn.expand('$HOME') .. '/.local/share/nvim/mason/packages/lombok-nightly/lombok.jar',
--     '--add-modules=ALL-SYSTEM',
--     '--add-opens', 'java.base/java.util=ALL-UNNAMED',
--     '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
--
--     -- 💀
--     -- '-jar', '/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
--     '-jar', vim.fn.expand('$HOME') .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
--     -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
--     -- Must point to the                                                     Change this to
--     -- eclipse.jdt.ls installation                                           the actual version
--
--
--     -- 💀
--     -- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
--     '-configuration', vim.fn.expand('$HOME') .. '/.local/share/nvim/mason/packages/jdtls/config_mac_arm',
--     -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
--     -- Must point to the                      Change to one of `linux`, `win` or `mac`
--     -- eclipse.jdt.ls installation            Depending on your system.
--
--
--     -- 💀
--     -- See `data directory configuration` section in the README
--     -- '-data', '/path/to/unique/per/project/workspace/folder'
--     -- '-data', vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
--
--     -- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
--     -- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
--     -- local workspace_dir = '/Users/alzar/.cache/jdtls_workspace/' .. project_name
--     -- '-data', workspace_dir,
--     '-data', vim.fn.stdpath('cache') .. '/jdtls_workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
--   },
--   root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
--   settings = {
--     java = {
--     }
--   },
--   init_options = {
--     bundles = {}
--   },
-- }
-- -- This starts a new client & server,
-- -- or attaches to an existing client & server depending on the `root_dir`.
-- require('jdtls').start_or_attach(config)




-- ~/.config/nvim/lua/jdtls_setup.lua (예: 별도 파일) 또는 지금 쓰시는 설정에 그대로 대체

local home = vim.fn.expand("$HOME")
local mason = home .. "/.local/share/nvim/mason/packages/jdtls"

local root_markers = {
  ".git",
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
}

local root_dir = vim.fs.root(0, root_markers)
if not root_dir then
  return
end

-- 1) equinox launcher JAR 실제 경로 해석 (와일드카드 금지 → glob로 찾기)
local function find_launcher()
  -- list=1 로 테이블 반환
  local matches = vim.fn.glob(mason .. "/plugins/org.eclipse.equinox.launcher_*.jar", 1, 1)
  local jar = (type(matches) == "table" and matches[1]) or ""
  if jar == nil or jar == "" then
    -- 버전 접미사 없는 fallback (당신 디렉토리에 존재)
    jar = mason .. "/plugins/org.eclipse.equinox.launcher.jar"
  end
  return jar
end

-- 2) macOS config 디렉토리 자동 선택 (+ 존재 검사)
local function find_config_dir()
  local candidates = { "config_mac_arm", "config_mac" }  -- arm 우선, 없으면 일반 mac
  for _, c in ipairs(candidates) do
    local p = mason .. "/" .. c
    if vim.loop.fs_stat(p) then return p end
  end
  -- 마지막 안전장치
  return mason .. "/config_mac"
end

-- 3) workspace 디렉토리(프로젝트별) 구성
-- root path 해시를 사용해 동명 디렉토리 충돌과 불필요 재인덱싱을 줄인다.
local workspace_id = vim.fn.sha256(root_dir):sub(1, 16)
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls_workspace/" .. workspace_id

local cmd = {
  -- Java 경로 (필요하면 절대경로로 교체)
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ERROR",
  "-Xmx3g",
  "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/lombok-nightly/lombok.jar",
  "--add-modules=ALL-SYSTEM",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  "-jar", find_launcher(),            -- ★ 와일드카드 대신 실제 파일 경로
  "-configuration", find_config_dir(),-- ★ config_mac_arm / config_mac 자동 선택
  "-data", workspace_dir,
}

local config = {
  cmd = cmd,
  root_dir = root_dir,
  settings = { java = {} },
  init_options = { bundles = {} },
}

require("jdtls").start_or_attach(config)
