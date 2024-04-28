<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.lang.*, dao.Question"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Live Test</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    margin-top: 50px;
    padding: 0;
    background-color: #f5f5f5;
    display: flex;
    justify-content: center;
}

.container {
    display: flex;
    flex-direction: row;
    width: 95%;
    height: 87vh;
    background-color: #fff;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    border-radius: 5px;
    overflow: hidden;
}

.question-section {
    flex: 4;
    padding: 20px;
    font-size: 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.question-item {
    margin-bottom: 15px;
}

.question-item h3 {
    margin-top: 0;
    color: #333;
}

.options {
    list-style-type: none;
    padding: 0;
    margin: 10px 0;
}

.options li {
    margin-bottom: 5px;
}

.options label {
    display: flex;
    align-items: center;
}

.options input[type="radio"] {
    margin-right: 10px;
}

.buttons-section {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

button {
    padding: 10px 20px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-right: 10px; /* Added margin between buttons */
}

button:hover {
    background-color: #3e8e41;
}

button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

#submitButton {
    background-color: #f44336;
}

#submitButton:hover {
    background-color: #d32f2f;
}

.question-nav {
    flex: 1;
    background-color: #9a9a9a;
    padding: 20px;
}

.question-nav ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
}

.question-nav li {
    margin-bottom: 10px;
}

.question-nav a {
    display: block;
    padding: 10px;
    background-color: #fff;
    border-radius: 5px;
    text-decoration: none;
    color: #333;
    transition: background-color 0.3s ease;
}

.question-nav a.answered {
    background-color: #4CAF50;
    color: white;
}

.question-nav a.unattempted {
    background-color: #fff;
    color: black;
}

.question-nav a.marked-for-review {
    background-color: #f5b700 !important;
    color: white;
}

.question-nav a:hover {
    background-color: #e0e0e0;
}
#markForReviewButton:hover {
	background-color: #f5b100;
}
button{
	color: black;
}
</style>
</head>
<body>

	<%
        HttpSession session2 = request.getSession(false);
        if (session2 != null && session2.getAttribute("user_id") != null) {
            //int user_id = (int) session2.getAttribute("user_id");
            //String name = (String) session2.getAttribute("name");
    %>

    <div class="container">
        <div class="question-section">
            <%
            ArrayList<Question> questions = (ArrayList<Question>) session.getAttribute("questions");
            if (questions != null) {
            %>
            <div class="question-item">
                <h3> Question <span id="questionNumber"></span>: </h3>
                <p> <span id="questionText"></span> </p>
                <ul class="options" id="optionsList">
                    <!-- Options will be dynamically populated here -->
                </ul>
            </div>
            <div class="buttons-section">
                <button id="prevButton" disabled>Previous</button>
                <button id="nextButton">Next</button>
                <button id="markForReviewButton" style="background-color: #f5b700">Mark for Review</button>
                <button id="submitButton" style="display: none; color: white;">Submit Test</button>
            </div>
            <%
            }
            %>
        </div>
        <div class="question-nav">
            <h2 style="color: white;">Questions</h2>
            <ul>
                <%
                for (int i = 0; i < questions.size(); i++) {
                %>
                <li> <a href="#" class="unattempted" data-question-index="<%=i%>"> Question <%=i + 1%> </a> </li>
                <%
                }
                %>
            </ul>
        </div>
    </div>

<script>
    const questionItems = document.querySelectorAll('.question-item');
    const questionLinks = document.querySelectorAll('.question-nav a');
    const prevButton = document.getElementById('prevButton');
    const nextButton = document.getElementById('nextButton');
    const markForReviewButton = document.getElementById('markForReviewButton');
    const submitButton = document.getElementById('submitButton');
    const questionNumberElement = document.getElementById('questionNumber');
    const questionTextElement = document.getElementById('questionText');
    const optionsListElement = document.getElementById('optionsList');
    const timerElement = document.getElementById('demo'); // Reference to the timer element

    const questions = [
        <%ArrayList<Question> arr = (ArrayList<Question>) session.getAttribute("questions");
		for (Question question : arr) 
		{%>
            {
                text: '<%=question.getQuesText().replaceAll("'", "\\'")%>',
                options: [
                    '<%=question.getOption1().replaceAll("'", "\\'")%>',
                    '<%=question.getOption2().replaceAll("'", "\\'")%>',
                    '<%=question.getOption3().replaceAll("'", "\\'")%>',
                    '<%=question.getOption4().replaceAll("'", "\\'")%>'
                ]
            },
        <%}%>
    ];

    let currentQuestionIndex = 0;
    const userResponses = new Array(questions.length).fill(null);
    const markedForReview = new Array(questions.length).fill(false);
    const totalTime = questions.length * 5 * 60; // 5 minutes per question, in seconds
    let remainingTime = totalTime;
    let timerInterval;

    function showQuestion(index) {
        const question = questions[index];
        questionNumberElement.textContent = index + 1;
        questionTextElement.innerHTML = question.text;

        optionsListElement.innerHTML = '';
        question.options.forEach((option, optionIndex) => {
            const listItem = document.createElement('li');
            const label = document.createElement('label');
            const radio = document.createElement('input');
            radio.type = 'radio';
            radio.name = 'option';
            radio.value = optionIndex + 1;
            radio.addEventListener('change', () => {
                userResponses[index] = optionIndex + 1;
                updateQuestionLink(index, 'answered');
            });
            if (userResponses[index] === optionIndex + 1) {
                radio.checked = true;
            }
            label.appendChild(radio);
            label.appendChild(document.createTextNode(option));
            listItem.appendChild(label);
            optionsListElement.appendChild(listItem);
        });

        questionLinks.forEach((link, i) => {
            if (i === index) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
            updateQuestionLink(i, markedForReview[i] ? 'marked-for-review' : userResponses[i] ? 'answered' : 'unattempted');
        });

        updateNavigationButtons();
    }

    function updateQuestionLink(index, status) {
        const link = questionLinks[index];
        link.classList.remove('unattempted', 'answered', 'marked-for-review');
        link.classList.add(status);
    }

    function updateNavigationButtons() {
        prevButton.disabled = currentQuestionIndex === 0;
        nextButton.disabled = currentQuestionIndex === questions.length - 1;
        submitButton.style.display = currentQuestionIndex === questions.length - 1 ? 'inline-block' : 'none';
    }

    function markForReview() {
        const currentIndex = currentQuestionIndex;
        markedForReview[currentIndex] = !markedForReview[currentIndex];
        updateQuestionLink(currentIndex, markedForReview[currentIndex] ? 'marked-for-review' : userResponses[currentIndex] ? 'answered' : 'unattempted');
    }
    function updateTimer() {
        const minutes = Math.floor(remainingTime / 60);
        const seconds = remainingTime % 60;
        timerElement.textContent = `<span class="math-inline">\{minutes\.toString\(\)\.padStart\(2, '0'\)\}\:</span>{seconds.toString().padStart(2, '0')}`;

        if (remainingTime === 0) {
            clearInterval(timerInterval);
            submitTest();
        }
        remainingTime--;
    }
    function submitTest() {
        const confirmSubmit = confirm('Do you want to submit the test?');
        if (confirmSubmit) {
            clearInterval(timerInterval);
            
            const answersString = userResponses.join(',');

            const form = document.createElement('form');
            form.setAttribute('method', 'post');
            form.setAttribute('action', '/TakeTest/Result');

            const answersInput = document.createElement('input');
            answersInput.setAttribute('type', 'hidden');
            answersInput.setAttribute('name', 'answers');
            answersInput.setAttribute('value', answersString);

            form.appendChild(answersInput);
            document.body.appendChild(form);
            form.submit();
        }
    }


    window.onload = function() {
        showQuestion(currentQuestionIndex); // Show the first question on load
        remainingTime = totalTime; // Reset remaining time on load
        timerInterval = setInterval(updateTimer, 1000); // Start the countdown timer
    };

    prevButton.addEventListener('click', () => {
        currentQuestionIndex--;
        showQuestion(currentQuestionIndex);
    });

    nextButton.addEventListener('click', () => {
        currentQuestionIndex++;
        showQuestion(currentQuestionIndex);
    });

    markForReviewButton.addEventListener('click', markForReview);

    submitButton.addEventListener('click', submitTest);

    questionLinks.forEach((link, index) => {
        link.addEventListener('click', () => {
            currentQuestionIndex = index;
            showQuestion(currentQuestionIndex);
        });
    });
</script>

	<%
        } else response.sendRedirect("/TakeTest/userPages/userLogin.jsp");
    %>
</body>
</html>