###
Save Root CAs to disk
###
fs = require 'fs'
path = require 'path'

all = require './all'
hash = require './hash'
mkdir = require './mkdir'
der2 = require './der2'

exports.path =
dst = path.join __dirname, '../pem'

mkdir dst, ->
  process.env.SSL_CERT_DIR = dst

  list = all der2.der
  hashes = {}
  names = {}

  pems = fs.createWriteStream path.join dst, roots = 'roots.pem'
  names[roots] = 1

  # Get name for file/symlink
  name = (hash)->
    hashes[hash] ||= 0
    n = "#{hash}.#{hashes[hash]++}"
    names[n] = 1
    n

  # Delete unused files
  drop = ->
    fs.readdir dst, (err, files)->
      throw err if err

      files = files.filter (file)->!names[file]

      do drop = (err = false)->
        throw err if err
        if files.length
          fs.unlink path.join(dst, files.pop()), drop

  do save = (err = false)->
    throw err if err

    unless list.length
      pems.end()
      do drop
      return

    pems.write text = der2 der2.txt, crt = list.pop()
    fs.writeFile path.join(dst, name hash crt), text, save
