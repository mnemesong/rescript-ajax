type formData

let structToFormData: {..} => formData

let getEmpty: {..}

let formDataToStruct: formData => {..}

let collectFormData: Dom.htmlElement => formData

let mergeFormData: (formData, formData) => formData
