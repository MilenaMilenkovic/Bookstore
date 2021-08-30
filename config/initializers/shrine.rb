require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "cache"),
  store: Shrine::Storage::FileSystem.new("public", prefix: ""),
}

Shrine.plugin :activerecord
Shrine.plugin :restore_cached_data
