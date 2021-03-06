class AuditsController < ApplicationController
  before_action :authenticate_user!
  def index
    authorize Audit
    @pagy, @audits = pagy(policy_scope(Audit).includes([:checklist]), items: Checklist::COUNT_ITEM_PAGY)

    # scope.includes(:checklist, responses: :question).where(user: user)
  end

  def new
    authorize Audit
    @checklist = Checklist.find(params[:audit][:checklist_id])
    responses = @checklist.questions.map { |question| Response.new(question: question) }
    @audit = @checklist.audits.build(responses: responses)
  end

  def create
    authorize Audit
    @audit = current_user.audits.new(audit_params)

    if @audit.save
      redirect_to audits_path, flash: { notice: t('.audit_create') }
    else
      render 'new'
    end
  end

  def edit
    @audit = policy_scope(Audit).includes(responses: :question)
                                .find(params[:id])
    authorize Audit
  end

  def update
    authorize Audit
    @audit = Audit.includes(responses: :question).find_by(id: params[:id])
    if @audit.update(audit_params)
      redirect_to audits_path, flash: { notice: t('.audit_edit') }
    else
      render 'edit', flash: { alert: t('.audit_not_edit') }
    end
  end

  def destroy
    authorize Audit
    @audit = policy_scope(Audit).find_by(id: params[:id])
    if @audit.destroy
      redirect_to audits_path, flash: { notice: t('.audit_deleted') }
    else
      render action: 'audit#index', flash: { alert: t('.audit_not_deleted') }
    end
  end
  
  private

  def audit_params
    params.require(:audit).permit(:checklist_id, responses_attributes: %i[id answer question_id description])
  end
end
