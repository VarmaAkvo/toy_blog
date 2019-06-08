# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_08_004532) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activity_notify_visits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_activity_notify_visits_on_user_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "striped_tags_content"
    t.string "tag_list"
    t.index "to_tsvector('english'::regconfig, (((((title)::text || ' '::text) || COALESCE(striped_tags_content, ' '::text)) || ' '::text) || (COALESCE(tag_list, ' '::character varying))::text))", name: "gin_index_on_articles", using: :gin
    t.index ["title"], name: "index_articles_on_title"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "blog_punishments", force: :cascade do |t|
    t.bigint "punisher_id", null: false
    t.bigint "punished_id", null: false
    t.datetime "expire_time", null: false
    t.index ["punished_id"], name: "index_blog_punishments_on_punished_id"
    t.index ["punisher_id", "punished_id"], name: "index_blog_punishments_on_punisher_id_and_punished_id", unique: true
    t.index ["punisher_id"], name: "index_blog_punishments_on_punisher_id"
  end

  create_table "comment_notify_visits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_comment_notify_visits_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "user_id", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.integer "floor", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "punishments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "expire_time", null: false
    t.index ["user_id"], name: "index_punishments_on_user_id"
  end

  create_table "relations", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.index ["followed_id", "follower_id"], name: "index_relations_on_followed_id_and_follower_id", unique: true
    t.index ["followed_id"], name: "index_relations_on_followed_id"
    t.index ["follower_id"], name: "index_relations_on_follower_id"
  end

  create_table "replies", force: :cascade do |t|
    t.bigint "comment_id", null: false
    t.bigint "user_id", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comment_id"], name: "index_replies_on_comment_id"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "reply_notify_visits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_reply_notify_visits_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "reason", null: false
    t.boolean "processed", default: false, null: false
    t.bigint "reporter_id", null: false
    t.bigint "reported_id", null: false
    t.string "reportable_type", null: false
    t.bigint "reportable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["processed"], name: "index_reports_on_processed"
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id"
    t.index ["reported_id"], name: "index_reports_on_reported_id"
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
  end

  create_table "tagging", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "taggable_type", null: false
    t.bigint "taggable_id", null: false
    t.index ["tag_id"], name: "index_tagging_on_tag_id"
    t.index ["taggable_type", "taggable_id", "tag_id"], name: "index_tagging_on_taggable_type_and_taggable_id_and_tag_id", unique: true
    t.index ["taggable_type", "taggable_id"], name: "index_tagging_on_taggable_type_and_taggable_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_articles_tags_statistics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.integer "total", null: false
    t.index ["tag_id"], name: "index_user_articles_tags_statistics_on_tag_id"
    t.index ["user_id", "tag_id"], name: "index_user_articles_tags_statistics_on_user_id_and_tag_id", unique: true
    t.index ["user_id"], name: "index_user_articles_tags_statistics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.string "profile", default: ""
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activity_notify_visits", "users"
  add_foreign_key "comment_notify_visits", "users"
  add_foreign_key "comments", "articles"
  add_foreign_key "comments", "users"
  add_foreign_key "punishments", "users"
  add_foreign_key "replies", "comments"
  add_foreign_key "replies", "users"
  add_foreign_key "reply_notify_visits", "users"
end
