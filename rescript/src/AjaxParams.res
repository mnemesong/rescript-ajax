type formData

let structToFormData: {..} => formData = %raw(` 
function(params) {
  const fd = new FormData();
  Object.keys(params).forEach(k => {
    fd.append(k, params[k]);
  });
  return fd;
} 
`)

let getEmpty: {..} = %raw(`{}`)

let formDataToStruct: formData => {..} = %raw(` 
function (formData) {
  const rec = {};
  for (const key of formData.keys()) {
    let vals = formData.getAll(key);
    (vals.length > 1) 
      ? rec[key] = vals
      : rec[key] = vals[0];
  }
  return rec;
} `)

let collectFormData: Dom.htmlElement => formData = %raw(`
function (container) {
  const formData = new FormData();
  const inputs = Array
    .from(container.getElementsByTagName('input'));
  inputs.forEach((input) => {
    if(input.type === 'checkbox') {
      formData.append(input.name, input.checked ? input.value : '');
    } else if (input.type === 'radio') {
      if(input.checked) {
        formData.append(input.name, input.value);
      }
    } else if(input.type === 'file') {
      if(input.files.length === 1) {
        formData.append(input.name, input.files[0]);
      } else {
        Array.from(input.files)
          .forEach((el) => formData.append(input.name + '[]', el));
      }
    } else {
      formData.append(input.name, input.value);
    }
  });
  const textAreas = Array
    .from(container.getElementsByTagName('textarea'));
  textAreas.forEach((textarea) => {
    formData.append(textarea.name, textarea.value);
  });
  const selects = Array
    .from(container.getElementsByTagName('select'));
  selects.forEach((select) => {
    formData.append(select.name, select.value);
  });
  return formData;
}
`)

let mergeFormData: (formData, formData) => formData = %raw(`
function (fd1, fd2) {
  const fd = new FormData();
  for (const key of fd1.keys()) {
    fd1.getAll(key).forEach(v => {
      fd.append(key, v);
    });
  }
  for (const key of fd2.keys()) {
    fd2.getAll(key).forEach(v => {
      fd.append(key, v);
    });
  }
  return fd;
}
`)
