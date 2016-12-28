class KnowledgePointsController < ApplicationController
  before_action :set_knowledge_point, only: [:show, :edit, :update, :destroy]

  # GET /knowledge_points
  # GET /knowledge_points.json
  def index
    @knowledge_points = KnowledgePoint.all
  end

  # GET /knowledge_points/all_children
  def all_children
    parent_id = params[:id]
    Rails.logger.info("Selected parent:" + parent_id)
    if parent_id.present? then
      @all_second_children = KnowledgePoint.all_children(parent_id)
    end

    Rails.logger.info("Found children:  #{@all_second_children.length}")

    respond_to do |format|
      format.html { redirect_to knowledge_points_url, notice: 'Knowledge points were successfully created.' }
      format.json { render json: @all_second_children }
    end

  end

  # GET /knowledge_points/1
  # GET /knowledge_points/1.json
  def show
  end

  # GET /knowledge_points/new
  def new
    @knowledge_point = KnowledgePoint.new
    @all_children = KnowledgePoint.all_children(-1)
    @all_second_children = []

  end

  # GET /knowledge_points/1/edit
  def edit
  end

  # POST /knowledge_points
  # POST /knowledge_points.json
  def create
    @knowledge_point = KnowledgePoint.new(knowledge_point_params)

    if @knowledge_point.thirdLevelKPSet.present? then
      Rails.logger.info("thirdLevelParent: #{@knowledge_point.thirdLevelParent}")

      parent_kp = KnowledgePoint.find(@knowledge_point.thirdLevelParent)
      create_knowledge_point(@knowledge_point.thirdLevelKPSet, 3, parent_kp.id, parent_kp.name)

    elsif @knowledge_point.secondLevelKPSet.present? then
      Rails.logger.info("secondLevelParent: #{@knowledge_point.secondLevelParent}")

      parent_kp = KnowledgePoint.find(@knowledge_point.secondLevelParent)
      create_knowledge_point(@knowledge_point.secondLevelKPSet, 2, parent_kp.id, parent_kp.name)

    elsif @knowledge_point.firstLevelKPSet.present? then
      Rails.logger.info("firstLevelKPSet: #{@knowledge_point.firstLevelKPSet}")
      create_knowledge_point(@knowledge_point.firstLevelKPSet, 1)

    else

    end

    respond_to do |format|
      format.html { redirect_to knowledge_points_url, notice: 'Knowledge points were successfully created.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /knowledge_points/1
  # PATCH/PUT /knowledge_points/1.json
  def update
    respond_to do |format|
      if @knowledge_point.update(knowledge_point_params)
        format.html { redirect_to @knowledge_point, notice: 'KnowledgePoint was successfully updated.' }
        format.json { render :show, status: :ok, location: @knowledge_point }
      else
        format.html { render :edit }
        format.json { render json: @knowledge_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /knowledge_points/1
  # DELETE /knowledge_points/1.json
  def destroy
    children = KnowledgePoint.all_children(@knowledge_point.id)
    if children.empty?
      @knowledge_point.destroy
      respond_to do |format|
        format.html { redirect_to knowledge_points_url, notice: 'KnowledgePoint was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to knowledge_points_url, notice: 'KnowledgePoint has children. Cannot be destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_knowledge_point
      @knowledge_point = KnowledgePoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def knowledge_point_params
      params.require(:knowledge_point).permit(:name, :firstLevelKP, :firstLevelKPSet,
       :secondLevelParent, :secondLevelKPSet, :thirdLevelGrandParent, :thirdLevelParent, :thirdLevelKPSet)
    end

    def print_knowledge_point (knowledge_point)
      Rails.logger.info("*********")
      Rails.logger.info("name: #{knowledge_point.name}")
      Rails.logger.info("parent_id: #{knowledge_point.parent_id}")
      Rails.logger.info("parent_name: #{knowledge_point.parent_name}")
      Rails.logger.info("memo: #{knowledge_point.memo}")

    end

    def create_knowledge_point(kps, level, parent_id = -1, parent_name = "" )
      Rails.logger.info("****parameters: parent->#{parent_name}, parent_id->#{parent_id}, level->#{level}.")

      kp_array = Array.new()
      if kps.present? then
        names = kps.split(/\r\n/)
        names.each do |name|
          obj = KnowledgePoint.new()
          obj.name = name.strip()
          obj.level = level
          obj.parent_id = parent_id
          obj.parent_name = parent_name
          begin
            obj.save
          rescue => e
            Rails.logger.error("Cannot save #{obj.name}", e)
          end

          Rails.logger.info("Created kp: name->#{obj.name}, parent->#{obj.parent_name}, parent_id->#{obj.parent_id}, level->#{obj.level}.")
          kp_array.push(obj)
        end
      end

      # return kp array
      kp_array
    end
end
