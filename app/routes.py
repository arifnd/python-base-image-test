from flask import request, jsonify
from .models import Todo
from . import db

def register_routes(app):
    @app.route('/')
    def index():
        return jsonify({"message": "Flask + SQLAlchemy running!"})

    @app.route('/todos', methods=['GET'])
    def get_todos():
        todos = Todo.query.all()
        return jsonify([todo.to_dict() for todo in todos])

    @app.route('/todos', methods=['POST'])
    def create_todo():
        data = request.get_json()
        new_todo = Todo(task=data.get('task'))
        db.session.add(new_todo)
        db.session.commit()
        return jsonify(new_todo.to_dict()), 201
