### Neovim plugin for highlighting text

This plugin highlights text in a buffer.

## Installation

Use your favorite plugin manager. For example with Lazy

```lua
{joonasjouttijarvi/highlightnvim}
```

and then require it in our config

```lua

require('highlightnvim')
```

### Customization

You can customize the highlight color by setting the following variables in your config.
example:

```lua
hi WordUnderCursor guibg=#hexcolor ctermbg=lightgrey
```
or with underline

```lua
hi WordUnderCursor gui=underline cterm=underline
```





