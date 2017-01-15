class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :edit, :update, :destroy]
  layout :problems_layout

  # GET /problems
  # GET /problems.json
  def index
    @problems = Problem.all
  end

  # GET /problems/1
  # GET /problems/1.json
  def show
    Rails.logger.info("urls: #{@problem.image_urls}")
    @problem.normalized_problem_text = normalized_html(@problem.problem_text)

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
    @problem.images.each do |image|
      Rails.logger.debug("edit>>>>image: #{image.image_url}" )
    end

    @answers = @problem.answers
    @images = @problem.images

  end

  # POST /problems
  # POST /problems.json
  def create
    @problem = Problem.new(problem_params)
    @problem.images = build_images()
    # @problem.image_ids = image_ids.to_s
    # @problem.image_urls = image_urls.join(',')
    @problem.normalized_problem_text = normalized_html(@problem.problem_text)
    @problem.answers = build_answers()


    respond_to do |format|
      if @problem.save
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
    @problem.normalized_problem_text = normalized_html(@problem.problem_text)
    @problem.images = build_images()
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


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params.require(:problem).permit(:problem_text, :answers)
    end

    def problems_layout
      Rails.logger.debug("******" + action_name)
      action_name.exclude?("new") ? "problems":"problem_new"
    end

    def normalized_html(problem_text)
      charCodeMap = { 60.chr => "&lt;", 62.chr => "&gt;", 10.chr  => "<br/>", 13.chr => "<br/>"}  #, 60.chr => "&lt;", 62.chr => "&gt;"
      charCodeMap.each do |key, value|
        problem_text = problem_text.gsub(key, value)
        # Rails.logger.debug("******: #{key}->#{value}, #{problem_text}")
      end
      problem_text
    end

    def build_answers
      answers = params['answers']

      problem_answers = []
      if answers
        answers.each do |answer_text|
          @answer = Answer.new()
          @answer.answer_text = answer_text
          problem_answers.push(@answer)
          Rails.logger.debug(">>>answer: #{answer_text}")
        end
      end
      problem_answers
    end

    def build_images
      uploaded_images = params['problem']['image_url']

      Rails.logger.debug(">>>>uploaded_images: #{uploaded_images}")
      # it is array as supporting multiple uploading
      images = []
      if uploaded_images
        uploaded_images.each do |uploaded_image|
          if save_image_file? (uploaded_image)
            image = Image.new()
            image.image_url = ApplicationHelper::UPLOAD_BASE_PATH + "/" + uploaded_image.original_filename
            images.push(image);
            Rails.logger.debug(">>>>uploaded_image: #{image.image_url}")
          end
        end
      end
      images
    end

    def save_image_file?(uploaded_image)
      name = uploaded_image.original_filename
      tempfile = uploaded_image.tempfile
      begin
        # create the file path
        imagePath = Rails.root.join('app/assets/images', 'uploads', name);

        # write the file
        File.open(imagePath, "wb") { |f| f.write(tempfile.read) }
      rescue Exception => e
        Rails.logger.error("Cannot save images.", e)
        false
      end

      true
    end
end
