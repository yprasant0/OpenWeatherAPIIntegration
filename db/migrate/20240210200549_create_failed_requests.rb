class CreateFailedRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :failed_requests do |t|
      t.jsonb :query_params
      t.string :request_type
      t.text :error_message
      t.string :status

      t.timestamps
    end
  end
end
