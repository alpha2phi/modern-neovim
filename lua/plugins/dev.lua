-- local plugin development
return {
  -- local plugins need to be explicitly configured with dir
  { dir = "~/workspace/alpha2phi/chatgpt.nvim", cmd = { "ChatGPT" }, build = { "./install.sh", ":UpdateRemotePlugins" } },
}
