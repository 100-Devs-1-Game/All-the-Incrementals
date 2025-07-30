class_name WorldState
extends Resource

# Any property in an @export/@export_storage variable in a Resource
# that is referenced here will be (de)serialized
#
# This will currently serialize more information than needed but has
# the advantage of zero effort saving/loading
#
#

# This will automatically store all the levels in all Minigames upgrade trees
# through recursion in those nested Resources
@export_storage var minigames: Array[MinigameData]

#
# whatever else need to saved, can either be added directly as variable
# or wrapped into another Resource

#@export_storage var reputation : float
#@export_storage var inventory: Array[EssenceStack]
