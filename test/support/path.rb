require 'fileutils'

module ARubyTestHelpers
  module Path
    # Path to the tmp directory for the tests
    def tmp_path
      result = ARuby.source_root.join("test", "tmp")
      FileUtils.mkdir_p(result)
      result
    end

    # Path to the "home" directory for the tests
    def home_path
      result = tmp_path.join("home")
      FileUtils.mkdir_p(result)
      result
    end

    # Cleans all the test temp paths
    def clean_paths
      FileUtils.rm_rf(tmp_path)
      FileUtils.mkdir_p(tmp_path)
    end
  end
end
