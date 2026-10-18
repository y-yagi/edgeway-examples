require "edgeway/test"
require "test_helper"

# Model-only tests use Edgeway::UnitTest: a database, but no requests.
class TodoModelTest < Edgeway::UnitTest
  def test_eager_load_reads_todos_and_comments_in_one_query
    a = Todo.create!(title: "a")
    Todo.create!(title: "b")
    a.comments.create!(body: "x")
    a.comments.create!(body: "y")
    db.log.clear

    todos = Todo.order(:id).eager_load(:comments).to_a
    assert_equal 1, db.log.size
    assert_includes db.log[0], "LEFT JOIN comments"
    assert_equal 2, todos.size
    assert_equal 2, todos[0].comments.to_a.size
    assert_equal "y", todos[0].comments.to_a[1].body
    assert_equal 0, todos[1].comments.to_a.size
    assert_equal 1, db.log.size
  end

  def test_eager_load_belongs_to
    a = Todo.create!(title: "a")
    a.comments.create!(body: "x")
    comments = Comment.eager_load(:todo).to_a
    assert_equal "a", comments[0].todo.title
  end

  def test_eager_load_keeps_the_limit_for_todos
    3.times { |i| Todo.create!(title: "t#{i}").comments.create!(body: "c") }
    todos = Todo.order(:id).limit(2).eager_load(:comments).to_a
    assert_equal 2, todos.size
  end
end
