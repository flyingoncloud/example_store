json.extract! knowledge_point, :id, :name, :parent_id, :parent_name, :level, :memo, :created_at, :updated_at
json.url knowledge_point_url(knowledge_point, format: :json)
