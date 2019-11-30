class DocUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production? || Rails.env.staging?
    storage :fog
  else
    storage :file
  end

  # process :save_file_size_in_model

  # def save_file_size_in_model
  #   model.file_size = file.size if model.respond_to?(:file_size)
  #   model.file_name = file.filename if model.respond_to?(:file_name)
  # end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # def extension_white_list
  #   %w(JPEG JFIF Exif TIFF BMP GIF PNG PPM PGM PBM PNM WebP HEIF BAT BPG CD5 DEEP ECW FITS FLIF ICO ILBM IMG IMG JPEG Nrrd PAM PCX PGF PLBM SGI SID TGA VICAR XISF CPT PSD PSP XCF CGM SVG AI CDR DrawingML HPGL HVIF MathML NAPLPS ODG PSTricks PGF TikZ ReGIS VML WMF Xar XPS EPS PDF PostScript PICT SWF XAML jpeg jfif exif tiff bmp gif png ppm pgm pbm pnm webp heif bat bpg cd5 deep ecw fits flif ico ilbm img img jpeg nrrd pam pcx pgf plbm sgi sid tga vicar xisf cpt psd psp xcf cgm svg ai cdr drawingml hpgl hvif mathml naplps odg pstricks pgf tikz regis vml wmf xar xps eps pdf postscript pict swf xaml ZIP zip TAR tar PDF pdf jpg JPG odp ODP)
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
