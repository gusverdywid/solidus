root = exports ? this

root.taxon_tree_menu = (obj, context) ->

<<<<<<< HEAD
  base_url = Spree.url(Spree.routes.taxonomy_taxons_path)
  admin_base_url = Spree.url(Spree.routes.admin_taxonomy_taxons_path)
=======
>>>>>>> Extract taxonomy jstree menu to a new file
  edit_url = admin_base_url.clone()
  edit_url.setPath(edit_url.path() + '/' + obj.attr("id") + "/edit");

  create:
    label: "<i class='icon-plus'></i> " + Spree.translations.add,
    action: (obj) -> context.create(obj)
  rename:
    label: "<i class='icon-pencil'></i> " + Spree.translations.rename,
    action: (obj) -> context.rename(obj)
  remove:
    label: "<i class='icon-trash'></i> " + Spree.translations.remove,
    action: (obj) -> context.remove(obj)
<<<<<<< HEAD
=======
  cut:
    separator_before : true,
    label: "<i class='icon-cut'></i> " + Spree.translations.cut,
    action: (obj) -> is_cut = true; context.cut(obj)
  paste:
    label: "<i class='icon-paste'></i> " + Spree.translations.paste,
    action: (obj) -> is_cut = false; context.paste(obj),
    "_disabled": is_cut == false
>>>>>>> Extract taxonomy jstree menu to a new file
  edit:
    separator_before: true,
    label: "<i class='icon-edit'></i> " + Spree.translations.edit,
    action: (obj) -> window.location = edit_url.toString()
