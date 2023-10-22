type formData

let structToFormData: 'p => formData

let formDataToStruct: formData => {..}

let collectFormData: Dom.htmlElement => formData

let mergeFormData: (formData, formData) => formData
