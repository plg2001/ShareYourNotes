json.extract! richiesta_admin, :id, :user_id, :content, :created_at, :updated_at
json.url richiesta_admin_url(richiesta_admin, format: :json)
