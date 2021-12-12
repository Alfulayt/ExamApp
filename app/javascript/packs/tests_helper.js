function questionComponents(id) {
    htmlString = `<!-- Question start here-->\n` +
        `<div class="bg-secondary text-white rounded p-3 mt-3 mb-3" data-question-id="${id}" id="main_question_${id}">\n` +
        `        <a class="btn float-end btn-danger text-white" title="Delete" data-question-id="${id}" id="delete_question_${id}">\n` +
        `          <i class="fa fa-trash" aria-hidden="true"></i>\n` +
        `        </a>\n` +
        `\n` +
        `        <div class="mt-3 mb-3">\n` +
        `          <label class="form-label">Question Title</label>\n` +
        `          <input type="text" name="questions[][title]" class="form-control">\n` +
        `        </div>\n` +
        `        <div class="mb-3">\n` +
        `          <label class="form-label">Question Description</label>\n` +
        `          <textarea class="form-control" name="questions[][description]"></textarea>\n` +
        `        </div>\n` +
        `\n` +
        `        <div class="mb-3">\n` +
        `          <label class="form-label">Question Options</label>\n` +
        `          <a id="add_option_${id}" class="btn btn-success float-end text-white" data-question-id="${id}" ><i class="fa fa-plus" aria-hidden="true"></i> Add Option </a>\n` +
        `\n` +
        `          <div id="options_place_${id}">\n` +
        `          </div>\n` +
        `\n` +
        `        </div>\n` +
        `</div>\n` +
        `<!-- Question end here-->`

    var tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlString
    return tempDiv
}

function questionOptionComponents(question_id,option_id,deletable = true){
    htmlString = `<!-- option start here-->\n` +
        `        <div class="input-group w-75 mb-2" data-question-id="${question_id}" data-option-id="${option_id}" id="question_option_${question_id}_${option_id}">\n` +
        `          <input type="text" class="form-control"  name="questions[][options][][title]" aria-label="Text input with radio button">\n` +
        `          <div class="input-group-text">\n` +
        `            <input class="form-check-input mt-0" type="radio" name="questions[][options][][correct][${question_id}]" aria-label="Radio button for following text input" ${deletable? "" : "checked"}>\n` +
        `            <small class="ms-2"> Correct Answer </small>\n` +
        `          </div>\n` +
        `          <div class="input-group-text">\n` +
        `             <a  class="btn ${deletable? 'text-danger' : 'text-muted'} m-0 p-0" data-question-id="${question_id}" data-option-id="${option_id}" id="delete_option_${question_id}_${option_id}"> <i class="fa fa-trash" aria-hidden="true"></i></a>\n` +
        `           </div>`+
        `        </div>\n` +
        ` <!-- option end here-->`
    var tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlString
    return tempDiv
}

document.addEventListener('turbolinks:load', () => {
    const questionsPlace = document.getElementById("questions_place");
    const addNewQuestionsButton = document.getElementById("add_new_question");
    const maxOptions = 4

    let questionsCounter = 0;
    let questionsOptionsCounter = {}

    if(addNewQuestionsButton)
    addNewQuestionsButton.addEventListener('click', function() {
        // add Questions
        questionsPlace.insertAdjacentElement('beforeend',questionComponents(questionsCounter))

        // add first option
        const optionsPlace = document.getElementById("options_place_" + questionsCounter);
        questionsOptionsCounter[questionsCounter] = 0
        optionsPlace.insertAdjacentElement('beforeend',
            questionOptionComponents(
                questionsCounter,
                questionsOptionsCounter[questionsCounter],
                false
            ))

        // add event Listener for add options button
        const addOption = document.getElementById("add_option_" + questionsCounter)
        addOption.addEventListener('click', function () {
            let questionId = addOption.dataset.questionId

            if (optionsPlace.children.length < maxOptions) {
                questionsOptionsCounter[questionId] += 1
                optionsPlace.insertAdjacentElement('beforeend',
                    questionOptionComponents(
                        questionId,
                        questionsOptionsCounter[questionId]
                    ))
            }else{
                alert("Max 4 options")
            }

            // add event Listener for delete question option
            const deleteOption = document.getElementById("delete_option_" + questionId + "_" + questionsOptionsCounter[questionId])
            deleteOption.addEventListener('click', function () {
                let questionId = deleteOption.dataset.questionId
                let optionId = deleteOption.dataset.optionId
                let questionOption = document.getElementById("question_option_" + questionId + "_" + optionId)
                if (questionOption)
                    questionOption.remove()
            });
        });

        // add event Listener for delete Question button
        const deleteQuestion = document.getElementById("delete_question_" + questionsCounter)
        deleteQuestion.addEventListener('click', function () {
            let questionId = addOption.dataset.questionId
            document.getElementById("main_question_" + questionId).remove()
        });

        questionsCounter++;
    });
})