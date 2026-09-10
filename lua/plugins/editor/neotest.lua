------------------------------
-- test runner
-- run the test under the cursor without leaving the buffer
------------------------------
return {
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap", -- for debugging (optional)
      "rcarriga/nvim-dap-ui", -- recommended
      "theHamsta/nvim-dap-virtual-text", -- recommended
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Test: run nearest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test: run file",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test: run last",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Test: debug nearest",
      },
      {
        "<leader>tk",
        function()
          require("neotest").run.stop()
        end,
        desc = "Test: stop",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test: toggle summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Test: show output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test: toggle output panel",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-java")({
            -- Optional configuration here
          }),
        },
        -- Repeat the sign icon as virtual text at the end of the test line.
        -- The gutter sign alone is easy to miss, and the sign column is shared
        -- with gitsigns and diagnostics.
        status = {
          virtual_text = true,
          signs = true,
        },
        -- consumers/output.lua only fires this listener when the position under
        -- the cursor has status == "failed", so it never triggers on a green
        -- run. `true` rather than the default "short" so the float carries the
        -- full stack trace instead of a truncated line.
        output = {
          open_on_run = true,
        },
        consumers = {
          -- No built-in consumer reports a successful run, which is why a pass
          -- looked like nothing happened. Consumer listeners are namespaced by
          -- key (see consumer_client in neotest/init.lua), so this coexists
          -- with the status/output/diagnostic listeners rather than replacing
          -- them.
          run_summary = function(client)
            client.listeners.results = function(adapter_id, results, partial)
              -- Skip the intermediate emit; update_results fires once with
              -- partial = true before the final payload.
              if partial then
                return
              end

              local counts = { passed = 0, failed = 0, skipped = 0 }
              for pos_id, result in pairs(results) do
                -- results also carry container positions (file, namespace);
                -- counting those would inflate the totals.
                local ok, tree = pcall(client.get_position, client, pos_id, { adapter = adapter_id })
                local is_test = not ok or not tree or tree:data().type == "test"
                if is_test and counts[result.status] then
                  counts[result.status] = counts[result.status] + 1
                end
              end

              local total = counts.passed + counts.failed + counts.skipped
              if total == 0 then
                return
              end

              local parts = { ("%d passed"):format(counts.passed) }
              if counts.failed > 0 then
                table.insert(parts, ("%d failed"):format(counts.failed))
              end
              if counts.skipped > 0 then
                table.insert(parts, ("%d skipped"):format(counts.skipped))
              end

              local level = counts.failed > 0 and vim.log.levels.ERROR or vim.log.levels.INFO
              vim.schedule(function()
                vim.notify(table.concat(parts, "  ·  "), level, { title = "Neotest" })
              end)
            end
          end,
        },
      })
    end,
  },
}
