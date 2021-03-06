unit MessagesConst;

interface

const
  //MainForm
  const_mess_close_application = 'Да затворя ли приложението?';
  //Tree
  const_mess_delete_item_treeview = 'Потвърдете за изтриване на клон: "%s" !';
  const_mess_delete_all_item_treeview = 'Потвърдете за изтриване на всички клонове!';
  const_mess_err_addchild_item_treeview = 'Моля, изберете клон на който да се добави елемент!';
  const_mess_err_delete_item_treeview = 'Моля, изберете клона който желаете да изтриете!';
  const_mess_err_select_item_treeview = 'Моля, изберете клон!';

  const_mess_delete_tab_tabcontrol = 'Потвърдете за изтриване на албум: "%s" !';

  //ImageForm
  const_mess_delete_image_record = 'Ще бъде изтрит целия зашис, да се направи ли?';
  const_mess_delete_image = 'Желаете ли да изтриете графика: "%s" ?';
  const_mess_error_index_chart = 'Няма такава графика!';
  const_mess_error_image_empty = 'Не съществува графика за запис!';

  //Editor
  const_mess_not_found_fig_number = 'Липсва номер на фигурата!';
  const_mess_error_fig_prefix = 'Неправилно зададена връзка. '+ #10#13 + 'Използвайте формата: "file:фиг.1"';
  const_mess_modified_editor = 'Направени са промени в текста.'+ #10#13 + 'Желаете ли да бъдат записани?';

  //UtilsImage
  const_mess_err_load_image = 'Непознат графичен формат!';

  //Archives
  const_mess_OverrideFile = 'Да презашиша ли архива?';
  const_mess_ReadyOK       = 'Готово.';
  const_mess_ArchiveOpen   = 'Данните при възстановяване от архив се записват върху текущите';
implementation

end.
