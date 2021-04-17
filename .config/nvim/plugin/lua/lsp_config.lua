local lspconfig = require('lspconfig')

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   vim.lsp.diagnostic.on_publish_diagnostics, {
     -- Enable diagnostic message updates in insert mode
     update_in_insert = true,
   }
 )

 -- Dart LSP configuration
local dart_capabilities = vim.lsp.protocol.make_client_capabilities()
dart_capabilities.textDocument.completion.completionItem.snippetSupport = true
dart_capabilities.textDocument.codeAction = {
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = {
        "",
        "quickfix",
        "refactor",
        "refactor.extract",
        "refactor.inline",
        "refactor.rewrite",
        "source",
        "source.organizeImports",
      };
    };
  };
}

lspconfig.dartls.setup {
  on_attach = on_attach;
  flags = {allow_incremental_sync = true},
  init_options = {
    onlyAnalyzeProjectsWithOpenFiles = true,
    outline = true,
    flutterOutline = true,
    suggestFromUnimportedLibraries = true,
    closingLabels = true,
  },
  capabilities = dart_capabilities;
}

-- Go LSP
lspconfig.gopls.setup {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = updated_capabilities
}

-- Elixir LSP
lspconfig.elixirls.setup{ 
  capabilities = capabilities,
  cmd = { "/home/thesmader/Installs/elixir-ls/release/language_server.sh" }; 
  on_attach = on_attach,
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      suggestSpecs = true
    }
  }
}

local chain_complete_list = {
  default = {
    {complete_items = {'lsp', 'snippet'}},
    {complete_items = {'buffers'}},
    {complete_items = {'path'}, triggered_only = {'/'}},
  },
  string = {
    {complete_items = {'path'}, triggered_only = {'/'}},
    {complete_items = {'buffers'}},
  },
  comment = {},
}

local servers = {"bashls", "clangd", "tsserver", "vimls", "gopls"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { on_attach = on_attach }
end

vim.cmd [[autocmd CursorHold * :lua vim.lsp.diagnostic.show_line_diagnostics()]]
vim.cmd [[autocmd CursorHoldI * silent! :lua vim.lsp.buf.signature_help()]]

