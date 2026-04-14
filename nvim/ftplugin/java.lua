local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", false, true)[1]

if not launcher or launcher == "" then
  vim.notify("jdtls not installed - run :MasonInstall jdtls", vim.log.levels.WARN)
  return
end

local root_dir = vim.fs.root(0, {
  "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git",
})
local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

require("jdtls").start_or_attach({
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", jdtls_path .. "/config_linux",
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {},
  },
})
