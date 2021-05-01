block_delimiter = "\r\n" 

text = File.read(File.expand_path("~/Desktop/target.txt"))
blocks = text.lines.chunk_while { |line| line != block_delimiter }.to_a

contents = blocks.map { |block| [block[0].prepend("### "), block[1]].join() }
contents.shift
File.open(File.expand_path("~/Desktop/new_target.txt"), "wb") { |f| f.write(contents.join())  }
