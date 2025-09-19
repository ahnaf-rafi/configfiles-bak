require("luasnip.session.snippet_collection").clear_snippets("tex")

local ls = require("luasnip")
local t = ls.text_node
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local isn = ls.indent_snippet_node
local sn = ls.snippet_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local extras = require("luasnip.extras")
-- local l = extras.lambda
-- local rep = extras.rep
-- local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
-- local postfix = require("luasnip.extras.postfix").postfix
-- local types = require("luasnip.util.types")
-- local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
-- local k = require("luasnip.nodes.key_indexer").new_key
--

return {
  s(
    {trig = "sum"},
    {t("\\sum_{"), i(1, "i = 1"), t("}^{"), i(2, "n"), t("} ")}
  ),

  s(
    {trig = "int"},
    {t("\\int_{"), i(1, "a"), t("}^{"), i(2, "b"), t("} "), i(0),
      t(" \\; \\mathrm{d} "), i(3, "x")}
  ),

  s(
    {trig = "wh"},
    {t("\\widehat{"), i(1), t("}")}
  ),

  s(
    {trig = "wt"},
    {t("\\widetilde{"), i(1), t("}")}
  ),

  s(
    {trig = "bb"},
    {t("\\mathbb{"), i(1), t("}")}
  ),

  s(
    {trig = "bf"},
    {t("\\mathbf{"), i(1), t("}")}
  ),

  s(
    {trig = "cal"},
    {t("\\mathcal{"), i(1), t("}")}
  ),

  s(
    {trig = "scr"},
    {t("\\mathscr{"), i(1), t("}")}
  ),

  s(
    {trig = "frak"},
    {t("\\mathfrak{"), i(1), t("}")}
  ),

  s(
    {trig = "rm"},
    {t("\\mathrm{"), i(1), t("}")}
  ),

  s(
    {trig = "sf"},
    {t("\\mathsf{"), i(1), t("}")}
  ),

  ms(
    {{trig = "frac"}, {trig = "fr"}},
    {t("\\frac{"), i(1), t("}{"), i(2), t("} ")}
  ),

  s(
    {trig = "ovs"},
    {t("\\overset{"), i(1), t("}{"), i(2), t("} ")}
  ),

  s(
    {trig = "uns"},
    {t("\\underset{"), i(1), t("}{"), i(2), t("} ")}
  ),

  s(
    {trig = "ovl"},
    {t("\\overline{"), i(1), t("}")}
  ),

  s(
    {trig = "unl"},
    {t("\\underline{"), i(1), t("}")}
  ),

  s(
    {trig = "uns"},
    {t("\\underset{"), i(1), t("}{"), i(2), t("} ")}
  ),

  s(
    {trig = "tsc"},
    {t("\\textsuperscript{"), i(1), t("}")}
  ),

  s(
    {trig = "tbf"},
    {t("\\textbf{"), i(1), t("}")}
  ),

  s(
    {trig = "=="},
    {t({"=", ""}), t("& \\, ")}
  ),

  ms(
    {{trig = "beg"}, {trig = "begin"}},
    {
      t("\\begin{"), i(1), t({"}", ""}),
      i(0),
      t({"", "\\end{"}),
      f(
        function(args, _)
          return args[1][1]
        end,
        {1},
        {}
      ),
      t("}")
    }
  ),

  ms(
    {{trig = "item"}, {trig = "itemize"}},
    {t({"\\begin{itemize}", " \\item "}), i(0), t({"", "\\end{itemize}"})}
  ),

  s({trig = "it"}, {t({"", "\\item "})}),

  ms(
    {{trig = "enum"}, {trig = "enumerate"}},
    {t({"\\begin{enumerate}", " \\item "}), i(0), t({"", "\\end{enumerate}"})}
  ),

  s(
    {trig = "ilm"},
    {t("\\("), i(0), t("\\)")}
  ),

  s(
    {trig = "eq"},
    {t({"\\begin{equation}", " "}), i(0), t({"", "\\end{equation}"})}
  ),

  s(
    {trig = "eqnn"},
    {t({"\\begin{equation*}", " "}), i(0), t({"", "\\end{equation*}"})}
  ),

  s(
    {trig = "al"},
    {t({"\\begin{align}", " "}), i(0), t({"", "\\end{align}"})}
  ),

  s(
    {trig = "alnn"},
    {t({"\\begin{align*}", " "}), i(0), t({"", "\\end{align*}"})}
  ),

  s(
    {trig = "spl"},
    {
      isn(
        1,
        {
          t({"\\begin{split}", " "}),
          i(1),
          t({"", "\\end{split}"})
        },
        "$PARENT_INDENT")
    }
  ),

  -- TODO: Figure out how to implement snippetnode for title and label.
  s(
    {trig = "thm"},
    {
      t("\\begin{theorem}"),
      sn(
        1,
        {t("["), i(1, "Name"), t({"]", "\\label{thm--"}), i(2), t({"}", ""})}
      ),
      i(0),
      t({"", "\\end{theorem}"})
    }
  ),

  s(
    {trig = "prf"},
    {
      t({"\\begin{proof}", ""}),
      i(0),
      t({"", "\\end{proof}"})
    }
  ),

  s(
    {trig = "lem"},
    {
      t("\\begin{lemma}"),
      sn(
        1,
        {t("["), i(1, "Name"), t({"]", "\\label{lem--"}), i(2), t({"}", ""})}
      ),
      i(0),
      t({"", "\\end{lemma}"})
    }
  ),

  s(
    {trig = "cor"},
    {
      t("\\begin{corollary}"),
      sn(
        1,
        {t("["), i(1, "Name"), t({"]", "\\label{cor--"}), i(2), t({"}", ""})}
      ),
      i(0),
      t({"", "\\end{corollary}"})
    }
  ),

  s(
    {trig = "def"},
    {
      t("\\begin{definition}"),
      sn(
        1,
        {t("["), i(1, "Name"), t({"]", "\\label{def--"}), i(2), t({"}", ""})}
      ),
      i(0),
      t({"", "\\end{definition}"})
    }
  ),

  s(
    {trig = "asm"},
    {
      t("\\begin{assumption}"),
      sn(
        1,
        {t("["), i(1, "Name"), t({"]", "\\label{asm--"}), i(2), t({"}", ""})}
      ),
      i(0),
      t({"", "\\end{assumption}"})
    }
  ),

  s(
    {trig = "rem"},
    {
      t("\\begin{remark}"),
      sn(
        1,
        {t("["), i(1, "Name"), t({"]", "\\label{rem--"}), i(2), t({"}", ""})}
      ),
      i(0),
      t({"", "\\end{remark}"})
    }
  ),

  s(
    {trig = "eg"},
    {
      t("\\begin{example}"),
      sn(
        1,
        {t("["), i(1, "Name"), t({"]", "\\label{eg--"}), i(2), t({"}", ""})}
      ),
      i(0),
      t({"", "\\end{example}"})
    }
  ),
  s(
    {trig = "prob"},
    {
      t({"\\begin{problem}", ""}),
      i(0),
      t({"", "\\end{problem}"})
    }
  ),

  -- Frames for beamer
  s(
    {trig = "frame"},
    {
      t({"\\begin{frame}", ""}),
      sn(
        1,
        {t("\\frametitle{"), i(1), t({"}", ""})}
      ),
      i(0),
      t({"", "\\end{frame}"})
    }
  ),

  s(
    {trig = "itfr"},
    {
      t({"\\begin{frame}", ""}),
      sn(
        1,
        {t("\\frametitle{"), i(1), t({"}", ""})}
      ),
      t({"\\begin{itemize}", ""}),
      t(" \\item "), i(0),
      t({"", "\\end{itemize}", ""}),
      t("\\end{frame}")
    }
  ),

  -- Left/right pairs
  s(
    {trig = "\\left(", snippetType = "autosnippet"},
    -- {t("\\left( "), i(0), t(" \\right)")}
    {t("\\left( "), i(0), t(" \\right"), i(1)}
  ),

  s(
    {trig = "\\left[", snippetType = "autosnippet"},
    -- {t("\\left[ "), i(0), t(" \\right]")}
    {t("\\left[ "), i(0), t(" \\right"), i(1)}
  ),

  s(
    {trig = "\\left\\{", snippetType = "autosnippet"},
    {t("\\left\\{ "), i(0), t(" \\right\\}")}
  ),

  s(
    {trig = "\\left|", snippetType = "autosnippet"},
    {t("\\left| "), i(0), t(" \\right|")}
  ),

  s(
    {trig = "\\left\\|", snippetType = "autosnippet"},
    {t("\\left\\| "), i(0), t(" \\right\\|")}
  ),

}
