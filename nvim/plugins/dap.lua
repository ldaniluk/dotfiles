local status_vt, dap_vt = pcall(require, "nvim-dap-virtual-text")
if status_vt then dap_vt.setup() end

local status_dp, dap_python = pcall(require, "dap-python")
if status_dp then dap_python.setup("python") end

local status_dui, dapui = pcall(require, "dapui")
if status_dui then dapui.setup() end

local status_dap, dap = pcall(require, "dap")
if status_dap then
    dap.adapters.codelldb = {
      type = 'server',
      port = "${port}",
      executable = {
        command = 'codelldb', 
        args = {"--port", "${port}"},
      }
    }
    dap.configurations.rust = {
      {
        name = "Rust debug",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
end