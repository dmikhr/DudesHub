    patch_pos_start = lines_with_file_paths.map { |line| patch_start_pos(line) }
    @patches = @patches.select { |patch| allowed_patch?(patch) }
  def allowed_patch?(patch)
    fname_string = patch.first
    extension_allowed = extract_file_paths(fname_string).last.end_with?(ALLOWED_EXTENSION)
    folder_allowed = !extract_file_paths(fname_string).last.start_with?(*EXCLUDE_ROOT_FOLDERS)

    extension_allowed && folder_allowed