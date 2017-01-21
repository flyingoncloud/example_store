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
    images = build_problem_images()
    Rails.logger.debug(">>>have new images: #{images.size}")
    @problem.images = images if images.size > 0

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
      params.require(:problem).permit(:problem_text, :answers, :answers_count)
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


    def build_answers
      answers = params['answers']
      answer_indexes = @problem.answers_count
      indexes = answer_indexes.split(" ")
      Rails.logger.debug("answer_indexes: #{answer_indexes}" )


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
