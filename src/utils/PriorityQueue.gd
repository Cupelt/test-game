extends RefCounted
class_name PriorityQueue

# Priority Queue implementation in GDScript
# (see: https://www.programiz.com/dsa/priority-inner_array)
# NOTE: the queue works with objects with an orderable (ie
# "less than comparable") priority property,  
# whose name can be specified (default: "priority")
var max_heap: bool # =true/false then queue in descending/ascending
var inner_array: Array
		
func _init(p_max_heap:bool=true):
	max_heap = p_max_heap
	inner_array = []
	
# Function to insert an element into the tree
func insert(obj: Variant, priority: float):
	var arr_size:int = inner_array.size()
	inner_array.append([obj, priority]) 
	if arr_size != 0:
		for i in range((arr_size / 2) - 1, -1, -1):
			_heapify(arr_size, i)

# Function to delete an element from the tree
func delete_node(obj: Variant):
	var arr_size:int = inner_array.size()
	var i = 0
	
	var obj_index = inner_array.find_custom(func (arr): return arr[0] == obj)
	if obj_index < 0 :
		push_warning("Object '", obj, "' cannot be deleted from the queue!")
		return
	
	while i < arr_size:
		if inner_array[obj_index][1] == inner_array[i][1]:
			break
		i += 1
	# Swap the element to delete with the last element
	var inner_array_i = inner_array[i]
	inner_array[i] = inner_array[arr_size - 1]
	inner_array[arr_size - 1] = inner_array_i
	# Remove the last element (the one we want to delete) = obj
	inner_array.pop_back()
	# Rebuild the heap
	arr_size = inner_array.size()
	for y in range((arr_size / 2) - 1, -1, -1):
		_heapify(arr_size, y)

func head():
	return inner_array[0][0]

func size():
	return inner_array.size()

# Function to heapify the tree
func _heapify(n, i):
	# Find the head (largest/lowest) among root, left child, and right child
	var head = i
	var l = 2 * i + 1
	var r = 2 * i + 2
	if max_heap:
		if l < n and inner_array[i][1] < inner_array[l][1]:
			head = l
		if r < n and inner_array[head][1] < inner_array[r][1]:
			head = r
	else:
		# min_heap
		if l < n and inner_array[i][1] > inner_array[l][1]:
			head = l
		if r < n and inner_array[head][1] > inner_array[r][1]:
			head = r
	# Swap and continue heapifying if root is not the head
	if head != i:
		var inner_array_i = inner_array[i]
		inner_array[i] = inner_array[head]
		inner_array[head] = inner_array_i
		_heapify(n, head)

### PriorityQueue TEST
#class ObjPrio extends RefCounted:
	#var prio:int
  #
	#func _init(p_prio:int):
		#prio = p_prio
#
#func _ready():    
	#const OBJ_NUM = 20
	#var prio_queue_max = PriorityQueue.new(true)
	#var prio_queue_min = PriorityQueue.new(false)
	#for i in OBJ_NUM:
		#var n = randi_range(-100, 100)
		#var obj = ObjPrio.new(n)
		#prio_queue_max.insert(obj, obj.prio)
		#prio_queue_min.insert(obj, obj.prio)
		#
	#print("descending ordered")
	#while prio_queue_max.size() > 0:
		#var head_node = prio_queue_max.head()
		#print("\t", head_node.prio)
		#prio_queue_max.delete_node(head_node)
	#print("ascending ordered")
	#while prio_queue_min.size() > 0:
		#var head_node = prio_queue_min.head()
		#print("\t", head_node.prio)
		#prio_queue_min.delete_node(head_node)
