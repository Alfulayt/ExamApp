
document.addEventListener('turbolinks:load', () => {
    const clickButton = document.getElementById("generate_pass");
    if (clickButton)
        clickButton.addEventListener('click', (event) => {
            genPassword()
        })

    const copyUserAccount = document.getElementById("copy_details");
    if (copyUserAccount)
        copyUserAccount.addEventListener('click', (event) => {
            copyUserAccountDetails()
        })
})



function genPassword() {
    const chars = "0123456789abcdefghijklmnopqrstuvwxyz!@#$%^&*()ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const passwordLength = 6;
    let password = "";
    for (var i = 0; i <= passwordLength; i++) {
        const randomNumber = Math.floor(Math.random() * chars.length);
        password += chars.substring(randomNumber, randomNumber +1);
    }
    document.getElementById("user_password").value = password;
    // document.getElementById("user_password_confirmation").value = password;
}

function copyUserAccountDetails() {
    var copyText = document.getElementById("copy-place");
    var range = document.createRange();
    range.selectNode(copyText);
    window.getSelection().removeAllRanges();
    window.getSelection().addRange(range);
    document.execCommand("copy");
    window.getSelection().removeAllRanges();

    alert("Copied !")
}