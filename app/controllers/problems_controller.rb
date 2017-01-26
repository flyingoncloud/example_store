class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :edit, :update, :destroy]
  layout :problems_layout

  # GET /problems
  # GET /problems.json
  def index
    @problems = Problem.all
    # if @problems then
    #   @problems.each do |problem|
    #     if problem.image_ids then
    #       @images = Image.where("id in ?", problem.image_ids )
    #       Rails.logger.debug("Found images: #{@images}")
    #     end
    #   end
    # end
  end

  # GET /problems/1
  # GET /problems/1.json
  def show
    Rails.logger.info("urls: #{@problem.image_urls}")


    # @problem.normalized_problem_text = normalized_html(@problem.problem_text)
    # @answers = @problem.answers
    # @images = @problem.images

  end

  # GET /problems/new
  def new
    @problem = Problem.new
  end

  # GET /problems/1/edit
  def edit
    Rails.logger.debug("edit>>>>: #{@problem.problem_text}" )
    @problem.answers.each do |answer|
      Rails.logger.debug("edit>>>>answer_text: #{answer.answer_text}" )
    end

    # @answers = @problem.answers
    # @images = @problem.images

  end

  # POST /problems
  # POST /problems.json
  def create
    @problem = Problem.new(problem_params)
    image_ids = build_problem_images()
    @problem.image_ids = image_ids.join(",") if image_ids.size > 0
    # @problem.image_ids = image_ids.to_s
    # @problem.image_urls = image_urls.join(',')
    # @problem.normalized_problem_text = normalized_html(@problem.problem_text)
    @problem.answers = build_answers()
    # answer_images = build_answer_images()

    saved_sucessful = false
    begin
      saved_sucessful = @problem.save
    rescue Exception => e
      Rails.logger.error("****Cannot save problem.", e)
    end


    respond_to do |format|
      if saved_sucessful
        format.html { redirect_to @problem, notice: 'Problem was successfully created.' }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { render :new }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problems/1
  # PATCH/PUT /problems/1.json
  def update
    # @problem.normalized_problem_text = normalized_html(@problem.problem_text)
    image_ids = get_or_build_problem_images(@problem)

    @problem.image_ids = image_ids

    @problem.answers = build_answers()

    Rails.logger.debug(">>>after normailzation: #{@problem.normalized_problem_text}")

    respond_to do |format|
      if @problem.update(problem_params)
        format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem }
      else
        format.html { render :edit }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problems/1
  # DELETE /problems/1.json
  def destroy
    @problem.destroy
    respond_to do |format|
      format.html { redirect_to problems_url, notice: 'Problem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_answer(answer)
    answer.destroy
    redirect_to problem_edit_path(@problem)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params.require(:problem).permit(:problem_text, :answers, :answers_count, :old_answer_index_id_maps, :deleted_old_answer_ids)
    end

    def problems_layout
      Rails.logger.debug("******" + action_name)
      action_name.exclude?("new") ? "problems":"problem_new"
    end

    # def normalized_html(problem_text)
    #   charCodeMap = { 60.chr => "&lt;", 62.chr => "&gt;", 10.chr  => "<br/>", 13.chr => "<br/>"}  #, 60.chr => "&lt;", 62.chr => "&gt;"
    #   charCodeMap.each do |key, value|
    #     problem_text = problem_text.gsub(key, value)
    #     # Rails.logger.debug("******: #{key}->#{value}, #{problem_text}")
    #   end
    #   problem_text
    # end

    def print(problem)
      Rails.logger.debug("Problem:[problem_text = #{problem.problem_text}, image_ids = #{problem.image_ids}]")
    end

    def get_or_build_answers(problem)
      # all answer indexes, including existing and new answers
      answer_indexes = params['problem']['answers_count']

      deleted_answer_ids = params['problem']['deleted_answer_id']
      Rails.logger.debug("Deleted answers: #{deleted_answer_ids}")

      if answer_indexes && answer_indexes.strip().length > 0
        indexes = answer_indexes.split(" ")
        Rails.logger.debug("answer_indexes: #{answer_indexes}" )
      end


      problem_answers = []
      if indexes
        indexes.each do |index|
          @answer = Answer.new()
          answer_text = params['answers_' + index]
          @answer.answer_text = answer_text
          image_ids = build_answer_images(index);
          @answer.image_ids = image_ids.join(",") if image_ids.size > 0;

          problem_answers.push(@answer)
          Rails.logger.debug(">>>answer: #{answer_text}, #{image_ids.join(",")}")
        end
      end
      problem_answers
    end

    def update_or_delete_old_answers
      old_answers = []
      # old answers
      old_answer_index_id_maps = params['problem']['old_answer_index_id_maps']

      if old_answer_index_id_maps && old_answer_index_id_maps.strip().length > 0
        old_answer_id_maps = old_answer_index_id_maps.scan(/(\d+):(\d+)/).map{ |key, value| [key, value]}
        Rails.logger.debug("old_answer_id_maps: #{old_answer_id_maps}" )
        old_answer_id_maps.each do |index, value|
          answer = Answer.find(value.to_i)

          Rails.logger.debug("Before answer[#{value}]: #{answer.answer_text}, #{answer.image_ids}")
          answer_text = params['answers_' + index]
          answer.answer_text = answer_text

          image_ids = build_answer_images(index);
          answer.image_ids = image_ids if image_ids && image_ids.size > 0
          answer.save

          Rails.logger.debug("After answer[#{value}]: #{answer.answer_text}, #{answer.image_ids}")
          old_answers.push(answer)
        end
      end

      deleted_answer_ids = params['problem']['deleted_old_answer_ids']
      # TODO: delete corresponding image and image files
      if deleted_answer_ids && deleted_answer_ids.strip().length > 0
        deleted_answer_ids.strip().split(" ").each do |deleted_answer_id|
          Rails.logger.debug("deleted old answer: #{deleted_answer_id}" )
          answer = Answer.find(deleted_answer_id.to_i)
          answer.destroy
        end
      end

      old_answers
    end

    def build_new_answers
      # new answers
      answer_indexes = params['problem']['answers_count']
      if answer_indexes && answer_indexes.strip().length > 0
        indexes = answer_indexes.split(" ")
        Rails.logger.debug("answer_indexes: #{answer_indexes}" )
      end


      problem_answers = []
      if indexes
        indexes.each do |index|
          @answer = Answer.new()
          answer_text = params['answers_' + index]
          @answer.answer_text = answer_text
          image_ids = build_answer_images(index);
          @answer.image_ids = image_ids.join(",") if image_ids.size > 0;
          problem_answers.push(@answer)
          Rails.logger.debug(">>>answer: #{answer_text}")
        end
      end
      problem_answers
    end

    def build_answers
      # new answers
      answers = []
      answers.concat(build_new_answers())
      Rails.logger.debug("Got new answers: #{answers.size}")

      answers.concat(update_or_delete_old_answers())
      Rails.logger.debug("After adding old answers, having: #{answers.size}")

      answers
    end

    def get_or_build_problem_images(problem)
      uploaded_images = params['problem']['image_url']

      Rails.logger.debug(">>>>uploaded_problem_images: #{uploaded_images}")
      # it is array as supporting multiple uploading
      images = []

      if uploaded_images
        # uploaded new image files, and delete old image records
        uploaded_images.each do |uploaded_image|
          image = Image.save(uploaded_image)
          images.push(image.id) if image
        end

        existing_images = problem.find_images()
        if existing_images
          existing_images.each do |image|
            image.destroy
            Rails.logger.debug("Delete existing image: #{image.id}, #{image.image_url}")
          end
        end
      end

      image_ids = problem.image_ids

      Rails.logger.debug("Find existing images: #{image_ids}")

      if images
        image_ids = images.join(",")
        Rails.logger.debug("Build new images: #{image_ids}")
      end

      image_ids
    end

    def build_problem_images
      uploaded_images = params['problem']['image_url']

      Rails.logger.debug(">>>>uploaded_problem_images: #{uploaded_images}")
      # it is array as supporting multiple uploading
      images = []
      if uploaded_images
        uploaded_images.each do |uploaded_image|
          image = Image.save(uploaded_image)
          images.push(image.id) if image
        end
      end
      images
    end

    def build_answer_images(index)
      uploaded_images = params['answer_image_url_' + index]

      Rails.logger.debug(">>>>uploaded answer images: #{uploaded_images}")
      # it is array as supporting multiple uploading
      images = []
      if uploaded_images
        uploaded_images.each do |uploaded_image|
            image = Image.save(uploaded_image)
            images.push(image.id) if image
        end
      end
      images
    end

    # def save_image_file?(uploaded_image)
    #   name = uploaded_image.original_filename
    #   tempfile = uploaded_image.tempfile
    #   begin
    #     # create the file path
    #     imagePath = Rails.root.join('app/assets/images', 'uploads', name);
    #
    #     # write the file
    #     File.open(imagePath, "wb") { |f| f.write(tempfile.read) }
    #   rescue Exception => e
    #     Rails.logger.error("Cannot save images.", e)
    #     false
    #   end
    #
    #   true
    # end
end
