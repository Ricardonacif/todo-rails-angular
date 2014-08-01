app = angular.module("Todo", ["ngResource", "ui.bootstrap", 'templates', "xeditable"])

app.run (editableOptions) ->
  editableOptions.theme = "bs3"
  return


$(document).on "ready page:load", ->
  angular.bootstrap document.body, ["Todo"]
  return

app.factory "Task", ["$resource" , ($resource) ->
  $resource("/tasks/:id.json", {id: "@id"}, {update: {method: "PUT"}, query:  {method: 'GET', isArray: true}})

]

app.factory "SubTask", ["$resource" , ($resource) ->
  $resource("/tasks/:task_id/sub_tasks/:id.json", {id: "@id", task_id: "@task_id"}, {update: {method: "PUT"}, query:  {method: 'GET', isArray: true}})

]

@TaskCtrl = ["$scope", "$filter", "Task", "$modal" ,  ($scope, $filter, Task, $modal) ->
  $scope.tasks = Task.query()
  orderBy = $filter('orderBy');

  
  $scope.addTask = ->
    task = Task.save($scope.newTask)
    $scope.tasks.push(task)
    $scope.tasks = orderBy($scope.tasks, 'sort_order', true)
    $scope.newTask = {}
    
  $scope.toggleCompleted = (task) ->    
    task.completed = ! task.completed
    task.$update()

  $scope.togglePublic = (task) ->    
    task.public = ! task.public
    task.$update()

  $scope.removeTask = (task) ->    
    task.$delete()
    $scope.tasks.splice( $scope.tasks.indexOf(task), 1 )

    
  $scope.checkBody = (data) ->
    if data.length < 1
      "Task can't be blank!"

  $scope.saveTask = (task) ->
    task.$update()
    
    

  $scope.editModal = (task) ->
    modalInstance = $modal.open(
      templateUrl: 'modal.html',
      controller: ModalInstanceCtrl,
      resolve:
        task: ->
          task      
    )
    modalInstance.result.then ((task) ->
    ), ->
      task.$update()
      

]

@ModalInstanceCtrl = ["$scope", "$filter", "Task", "$modal" , 'task', '$modalInstance', "SubTask",  ($scope, $filter, Task, $modal, task, $modalInstance, SubTask) ->
  orderBy = $filter('orderBy');
  
  $scope.task = task
  $scope.subTask = new SubTask({task_id: $scope.task.id, completed: false});

  $scope.close = ->    
    $modalInstance.dismiss('cancel')

  $scope.removeSubTask = (subTask) ->
    $scope.task.sub_tasks.splice( $scope.task.sub_tasks.indexOf(subTask), 1 )
    subTask = new SubTask(subTask);
    subTask.$delete()
    
  $scope.toggleCompleted = (subTask) ->
    subTask.completed = ! subTask.completed
    subTask = new SubTask(subTask);
    subTask.$update()


  $scope.saveSubTask = ->
    $scope.subTask.$save()
    unless $scope.task.sub_tasks?
      $scope.task.sub_tasks = []
    $scope.task.sub_tasks.push($scope.subTask)
    $scope.task.sub_tasks = orderBy($scope.task.sub_tasks, 'sort_order', true)
    $scope.subTask = new SubTask({task_id: $scope.task.id, completed: false})

  $scope.checkBody = (data) ->
    if data.length < 1
      "Task can't be blank!"

  $scope.updateSubTask = (subTask) ->
    subTask = new SubTask(subTask);
    subTask.$update()
    
]