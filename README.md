# Vim-contemplate

## Overview

[Vim-projectionist](https://github.com/tpope/vim-projectionist) was my go to for a long time for auto templating new files, but it's fairly limited in the kind of substitution it can do (it's limited to the name of the file basically). There's a variety of other scaffolding plugins out there, some that make use of or wrap vim's existing skeleton feature and there are lots of snippet expanders out there, but I couldn't find anything that would do both. I want to open a file, have it populate with a template, but then _also_ give me an opportunity to replace certain pieces using tabstops. I didn't want to rewrite the snippet expansion part however, as that's definitely the trickier part of this and UltiSnips (as well as other libraries) do it so well already. This plugin attempts to bridge that gap by reading skeleton files that may or may not have snippet expansions and when they do, registering them as one-time anonymous snippets with UltiSnips. When they don't, they're populated in the new buffer as is. If you want to use the snippet expanion part (and there's not much reason to use this plugin if you don't), you need to install [UltiSnips](https://github.com/SirVer/ultisnips) as well.

## Installation

If you don't have a preferred installation method, I really like vim-plug and recommend it.

#### Manual

Clone this repository and copy the files in plugin/, autoload/, and doc/ to their respective directories in your vimfiles, or copy the text from the github repository into new files in those directories. Make sure to run `:helptags`.

#### Plug (https://github.com/junegunn/vim-plug)

Add the following to your vimrc, or something sourced therein:

```vim
Plug 'SirVer/ultisnips'
Plug 'tandrewnichols/vim-contemplate'
```

Then install via `:PlugInstall`

#### Vundle (https://github.com/gmarik/Vundle.vim)

Add the following to your vimrc, or something sourced therein:

```vim
Plugin 'SirVer/ultisnips'
Plugin 'tandrewnichols/vim-contemplate'
```

Then install via `:BundleInstall`

#### NeoBundle (https://github.com/Shougo/neobundle.vim)

Add the following to your vimrc, or something sourced therein:

```vim
NeoBundle 'SirVer/ultisnips'
NeoBundle 'tandrewnichols/vim-contemplate'
```

Then install via `:BundleInstall`

#### Pathogen (https://github.com/tpope/vim-pathogen)

```sh
git clone https://github.com/SirVer/ultisnips.git ~/.vim/bundle/ultisnips
git clone https://github.com/tandrewnichols/vim-contemplate.git ~/.vim/bundle/vim-contemplate
```

## Usage

Create templates in `$HOME/.vim/skeletons` by filetype and subtype, like `$HOME/.vim/skeletons/javascript/react-component.js` for example, or set `g:contemplate_skeleton_dir` to put them elsewhere (but they still need to be organized by filetype). Then you can use them in one of two ways.

### Manually

You can use `:Contemplate [filetype] [type]` or `:Contemplate [type] [filetype]` to load templates ad hoc. I went to great lengths to make `filetype` and `type` work as seamlessly as possible, including tab completion. In general, filetype and type are optional and can be supplied in any order. If neither is supplied and the current buffer doesn't have a filetype set, you'll be prompted to choose a filetype from those present in `$HOME/.vim/skeletons`. Similarly, if you don't provide a type, you'll be prompted with a list of templates inside the filetype directory you provide or choose. If you provde only a type and the current buffer does not have a filetype, you'll be prompted to choose from any types in any filetype directories that match the type you provide. That is, if you have a `component` type in both `skeletons/javascript` and `skeletons/html`, and you don't provide a filetype and the current buffer doesn't have one either, you'll be prompted to choose between `html` and `javascript`. After all is said and done, if the current buffer doesn't have a filetype, it'll be set for you based on the template you chose. You can actually use the manual method anywhere in an existing file with or without contents, and it'll populate the template on your current line, leaving everything else untouched. Super flexible.

### Automatically on load

I.e. exactly the way vim's built-in skeletons work (except you still have to set that up). Automatic loading is triggered by the presense of `g:contemplate_autoscaffold` as a dict with keys. Each key should be an autocommand pattern and each value the template to load when a file matching that pattern is created. You can be as sparse as you want for specific filenames: `{ 'component.js': 'component' }`. Or more detailed for templating all files in particular directories: `{ 'src/app/components/*.js': 'component' }`.

### Snippets

Once a template is populated via one of the methods above, you can use tab to move through tabstops in the normal UltiSnips way. All the normal UltiSnips features work exactly as advertised; no need to do anything special. As an example, here's the react redux container template I use:

```javascript
import { connect } from 'react-redux';
import ${1:Component} from './component';
import { withRouter } from 'react-router-dom';

const mapStateToProps = (${2}) => {
  return {${3}};
};

const mapDispatchToProps = (dispatch) => {
  return {
    ${0}
  };
};

export default withRouter(connect(mapStateToProps, mapDispatchToProps)($1));
```

The first tab stop is the name of the component (defaulting to `Component`). As you type, the `$1` in the export statement at the end also gets populated. After typing the component name, `<Tab>` takes me to the function arguments for `mapStateToProps` and then to the returned props, etc. etc. `${0}` is the final tabstop at which point UltiSnips releases the tab key so that it works normally again. `<Esc>` will also release the tab key. See the [UltiSnips](https://github.com/SirVer/ultisnips) documentation for a full range of supported features.

## Contributing

I always try to be open to suggestions, but I do still have opinions about what this should and should not be so . . . it never hurts to ask before investing a lot of time on a patch.

## License

See [LICENSE](./LICENSE)
