
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
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local cmd = {
  -- Java 경로 (필요하면 절대경로로 교체)
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ERROR",
  -- JVM heap/GC tuning for large Java workspaces
  "-Xms512m",
  "-Xmx4g",
  "-XX:+UseG1GC",
  "-XX:MaxGCPauseMillis=200",
  "-XX:+UseStringDeduplication",
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
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 200,
  },
  settings = {
    java = {
      completion = {
        -- Exclude common noisy packages from completion candidates.
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
        guessMethodArguments = false,
      },
    },
  },
  init_options = { bundles = {} },
}

require("jdtls").start_or_attach(config)
