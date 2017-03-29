{CompositeDisposable} = require 'atom'
jsBeautify = require 'js-beautify'

module.exports =
  vueComponentBeautifyView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'vue-component-beautify:beautify', => @beautify()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @vueComponentBeautifyView.destroy()

  serialize: ->

  beautify: (state) ->
    self = this
    editor = atom.workspace.getActiveTextEditor()
    text = editor.getText()
    newTextArr = []
    ['html', 'js', 'css'].forEach((value) ->
      newText = self.replaceText(text, value)
      newTextArr.push(newText)

      console.log '#######', text, value, newText
    )
    editor.setText(newTextArr.join('\n\n'))

  replaceText: (text, type) ->
    beautify = {
      css: jsBeautify.css
      html: jsBeautify.html,
      js: jsBeautify.js
    }
    regObj = {
      css: /<style(\s|\S)*>(\s|\S)*<\/style>/gi,
      html: /<template(\s|\S)*>(\s|\S)*<\/template>/gi,
      js: /<script(\s|\S)*>(\s|\S)*<\/script>/gi
    }

    contentRex = />(\s|\S)*<\//g

    if regObj[type].exec(text)
      console.log regObj[type].exec(text)
      typeText = regObj[type].exec(text)[0]
    else
      return ''

    if typeText
      typeTextCon = contentRex.exec(typeText)[0]
      typeContent = typeTextCon.substring(1).substr(0,typeTextCon.length - 3)
      typeArr = typeText.split(typeContent)
      options =
        indent_size: 2

      beautifiedText = beautify[type](typeContent, options)
      # console.log beautifiedText
      return typeArr[0] + '\n' + beautifiedText + '\n' + typeArr[1]
    else
      return ''
