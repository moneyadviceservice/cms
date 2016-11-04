# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161104151936) do

  create_table "category_promos", force: true do |t|
    t.string  "promo_type"
    t.string  "title",       null: false
    t.string  "description"
    t.string  "locale",      null: false
    t.string  "url"
    t.integer "category_id", null: false
  end

  add_index "category_promos", ["locale"], name: "index_category_promos_on_locale", using: :btree

  create_table "comfy_cms_blocks", force: true do |t|
    t.string   "identifier",                      null: false
    t.text     "content",        limit: 16777215
    t.integer  "blockable_id"
    t.string   "blockable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_blocks", ["blockable_id", "blockable_type"], name: "index_comfy_cms_blocks_on_blockable_id_and_blockable_type", using: :btree
  add_index "comfy_cms_blocks", ["identifier"], name: "index_comfy_cms_blocks_on_identifier", using: :btree

  create_table "comfy_cms_categories", force: true do |t|
    t.integer "site_id",                                null: false
    t.string  "label",                                  null: false
    t.string  "categorized_type",                       null: false
    t.string  "title_en"
    t.string  "title_cy"
    t.string  "description_en"
    t.string  "description_cy"
    t.string  "title_tag_en"
    t.string  "title_tag_cy"
    t.integer "parent_id"
    t.integer "ordinal",                default: 999
    t.boolean "navigation"
    t.string  "image"
    t.string  "preview_image"
    t.boolean "third_level_navigation", default: false
    t.integer "small_image_id"
    t.integer "large_image_id"
  end

  add_index "comfy_cms_categories", ["parent_id"], name: "index_comfy_cms_categories_on_parent_id", using: :btree
  add_index "comfy_cms_categories", ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true, using: :btree

  create_table "comfy_cms_categorizations", force: true do |t|
    t.integer "category_id",                    null: false
    t.string  "categorized_type",               null: false
    t.integer "categorized_id",                 null: false
    t.integer "ordinal",          default: 999
  end

  add_index "comfy_cms_categorizations", ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true, using: :btree

  create_table "comfy_cms_files", force: true do |t|
    t.integer  "site_id",                                    null: false
    t.integer  "block_id"
    t.string   "label",                                      null: false
    t.string   "file_file_name",                             null: false
    t.string   "file_content_type",                          null: false
    t.integer  "file_file_size",                             null: false
    t.string   "description",       limit: 2048
    t.integer  "position",                       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_files", ["site_id", "block_id"], name: "index_comfy_cms_files_on_site_id_and_block_id", using: :btree
  add_index "comfy_cms_files", ["site_id", "file_file_name"], name: "index_comfy_cms_files_on_site_id_and_file_file_name", using: :btree
  add_index "comfy_cms_files", ["site_id", "label"], name: "index_comfy_cms_files_on_site_id_and_label", using: :btree
  add_index "comfy_cms_files", ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position", using: :btree

  create_table "comfy_cms_layouts", force: true do |t|
    t.integer  "site_id",                                     null: false
    t.integer  "parent_id"
    t.string   "app_layout"
    t.string   "label",                                       null: false
    t.string   "identifier",                                  null: false
    t.text     "content",    limit: 16777215
    t.text     "css",        limit: 16777215
    t.text     "js",         limit: 16777215
    t.integer  "position",                    default: 0,     null: false
    t.boolean  "is_shared",                   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_layouts", ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_layouts", ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true, using: :btree

  create_table "comfy_cms_pages", force: true do |t|
    t.integer  "active_revision_id"
    t.integer  "site_id",                                                            null: false
    t.integer  "layout_id"
    t.integer  "parent_id"
    t.integer  "target_page_id"
    t.string   "label",                                                              null: false
    t.string   "slug"
    t.string   "full_path",                                                          null: false
    t.text     "content_cache",                     limit: 16777215
    t.integer  "position",                                           default: 0,     null: false
    t.integer  "children_count",                                     default: 0,     null: false
    t.boolean  "is_published",                                       default: true,  null: false
    t.boolean  "is_shared",                                          default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "meta_description"
    t.string   "preview_cache"
    t.boolean  "regulated",                                          default: false
    t.string   "meta_title"
    t.string   "translation_id"
    t.datetime "scheduled_on"
    t.integer  "page_views",                                         default: 0
    t.boolean  "suppress_from_links_recirculation",                  default: false
    t.datetime "published_at"
    t.boolean  "supports_amp",                                       default: true
  end

  add_index "comfy_cms_pages", ["active_revision_id"], name: "index_comfy_cms_pages_on_active_revision_id", using: :btree
  add_index "comfy_cms_pages", ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_pages", ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path", using: :btree

  create_table "comfy_cms_revisions", force: true do |t|
    t.string   "record_type",                  null: false
    t.integer  "record_id",                    null: false
    t.text     "data",        limit: 16777215
    t.datetime "created_at"
  end

  add_index "comfy_cms_revisions", ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_rtype_and_rid_and_created_at", using: :btree

  create_table "comfy_cms_sites", force: true do |t|
    t.string  "label",                       null: false
    t.string  "identifier",                  null: false
    t.string  "hostname",                    null: false
    t.string  "path"
    t.string  "locale",      default: "en",  null: false
    t.boolean "is_mirrored", default: false, null: false
  end

  add_index "comfy_cms_sites", ["hostname"], name: "index_comfy_cms_sites_on_hostname", using: :btree
  add_index "comfy_cms_sites", ["is_mirrored"], name: "index_comfy_cms_sites_on_is_mirrored", using: :btree

  create_table "comfy_cms_snippets", force: true do |t|
    t.integer  "site_id",                                     null: false
    t.string   "label",                                       null: false
    t.string   "identifier",                                  null: false
    t.text     "content",    limit: 16777215
    t.integer  "position",                    default: 0,     null: false
    t.boolean  "is_shared",                   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_snippets", ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true, using: :btree
  add_index "comfy_cms_snippets", ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position", using: :btree

  create_table "comfy_cms_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                   default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role"
  end

  add_index "comfy_cms_users", ["email"], name: "index_comfy_cms_users_on_email", unique: true, using: :btree
  add_index "comfy_cms_users", ["reset_password_token"], name: "index_comfy_cms_users_on_reset_password_token", unique: true, using: :btree

  create_table "links", force: true do |t|
    t.string  "linkable_type", null: false
    t.integer "linkable_id",   null: false
    t.string  "text",          null: false
    t.string  "url",           null: false
    t.string  "locale",        null: false
  end

  create_table "page_feedbacks", force: true do |t|
    t.integer  "page_id"
    t.boolean  "liked",      default: true
    t.text     "comment"
    t.string   "shared_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id"
  end

  add_index "page_feedbacks", ["page_id", "liked"], name: "index_page_feedbacks_on_page_id_and_liked", using: :btree
  add_index "page_feedbacks", ["page_id"], name: "index_page_feedbacks_on_page_id", using: :btree
  add_index "page_feedbacks", ["session_id"], name: "index_page_feedbacks_on_session_id", using: :btree

  create_table "redirect_versions", force: true do |t|
    t.string   "item_type",                     null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 2147483647
    t.datetime "created_at"
  end

  add_index "redirect_versions", ["item_type", "item_id"], name: "index_redirect_versions_on_item_type_and_item_id", using: :btree

  create_table "redirects", force: true do |t|
    t.string   "source",                       null: false
    t.string   "destination",                  null: false
    t.string   "redirect_type",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",        default: true
  end

  add_index "redirects", ["source"], name: "index_redirects_on_source", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["value"], name: "index_tags_on_value", unique: true, using: :btree

end
