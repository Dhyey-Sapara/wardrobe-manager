namespace :images do
  desc "Compress all existing cloth images in storage"
  task compress: :environment do
    cloths = Cloth.with_attached_image.where.not(active_storage_attachments: { id: nil })
    total = cloths.count

    puts "Found #{total} cloth(es) with images."

    cloths.each.with_index(1) do |cloth, i|
      blob = cloth.image.blob
      print "[#{i}/#{total}] #{cloth.name} (#{blob.byte_size / 1024}KB) ... "

      blob.open do |tempfile|
        compressed = ImageProcessing::MiniMagick
          .source(tempfile)
          .resize_to_limit(1200, 1200)
          .saver(quality: 50)
          .call

        blob.upload(compressed)
        compressed.close!
      end

      blob.reload
      puts "done (#{blob.byte_size / 1024}KB)"
    rescue => e
      puts "failed — #{e.message}"
    end

    puts "Finished."
  end
end
