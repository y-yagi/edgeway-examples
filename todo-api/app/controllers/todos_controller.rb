class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos?done=true&ids=1,2&q=text&created_from=2026-01-01&order=title&dir=desc.
  # X-Total-Count: all the todos that match, beyond the 50 answered.
  # ids= (empty) matches nothing, and a value that is not a number counts as 0.
  def index
    todos = Todo.order(params.fetch("order", "id"), params.fetch("dir", "asc"))
    todos = filter(todos)
    headers["X-Total-Count"] = todos.count.to_s
    render json: todos.limit(50)
  end

  # GET /todos/stats: the numbers of done and open todos, by raw SQL.
  def stats
    rows = Edgeway::Model.select_all("SELECT done, COUNT(*) AS count FROM todos GROUP BY done", [])
    counts = { "done" => 0, "open" => 0 }
    rows.each { |row| counts[row["done"].to_i == 1 ? "done" : "open"] = row["count"].to_i }
    render json: counts
  end

  def show = render json: @todo

  def create
    todo = Todo.create!(todo_params)
    render json: todo, status: :created
  end

  def update
    @todo.update!(todo_params)
    render json: @todo
  end

  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def filter(todos)
    todos = todos.where("done" => params["done"]) if params.key?("done")
    todos = todos.where(id: params["ids"].split(",").map(&:to_i)) if params.key?("ids")
    todos = todos.where("title LIKE ?", "%#{params["q"]}%") if params.key?("q")
    created_range(todos)
  end

  def created_range(todos)
    from = params["created_from"]
    to = params["created_to"]
    return todos.where(created_at: from..to) if from && to
    return todos.where(created_at: (from..)) if from
    return todos.where(created_at: (..to)) if to
    todos
  end

  def set_todo
    @todo = Todo.find(params["id"])
  end

  def todo_params = params.require(:todo).permit(:title, :done, :priority)
end
