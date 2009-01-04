class CreateSpeakers < ActiveRecord::Migration
  def self.up
    create_table :speakers do |t|
      t.integer     :user_id
      t.integer     :paper_id
      t.timestamps
    end
    add_index( :speakers, [:user_id, :paper_id], :unique => true, :name => 'idx_unique_user_id_paper_id_on_speakers' )
  end

  def self.down
    drop_table :speakers
  end
end
