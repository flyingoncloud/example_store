json.extract! problem, :id, :problem_text, :image_url, :created_at, :updated_at
json.url problem_url(problem, format: :json)
