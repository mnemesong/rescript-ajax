type formData

let structToFormData: {..} => formData = %raw(` 
function(params) {
  const fd = new FormData();
  Object.keys(params).forEach(k => {
    fd.append(k, fd[k]);
  });
  return fd;
} 
`)

let formDataToStruct: formData => {..} = %raw(` 
function (formData) {
  const rec = {};
  for (const key of formData.keys()) {
    let vals = formData.getAll(key);
    (vals.length > 0) 
      ? rec[key] = vals
      : rec[key] = vals[0];
  }
  return rec;
} `)

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
