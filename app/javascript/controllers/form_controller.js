document.addEventListener('DOMContentLoaded', function() {
  const addSkillButton = document.getElementById('add_skill');
  const skillsContainer = document.getElementById('skills');

  addSkillButton.addEventListener('click', function() {
      // Use the Rails route helper here:
      const url = '<%= new_freelancer_profile_skill_path(@profile.id) %>';

      fetch(url) // Fetch the new skill form from the server
      .then(response => response.text())
      .then(html => {
          skillsContainer.insertAdjacentHTML('beforeend', html); // Add the new skill form to the page

          // Add event listener to the submit button of the newly created skill form
          const newSkillForm = skillsContainer.lastElementChild.querySelector('form');
          newSkillForm.addEventListener('submit', function(event) {
              event.preventDefault(); // Prevent default form submission
              const formData = new FormData(newSkillForm);

              fetch(newSkillForm.action, {
                  method: 'POST',
                  body: formData,
                  headers: {
                      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                  }
              })
              .then(response => response.json())
              .then(data => {
                  if (data.success) {
                      // Handle success (e.g., show a message, update the UI)
                      console.log('Skill added successfully:', data);
                  } else {
                      // Handle error (e.g., show an error message)
                      console.error('Error adding skill:', data.errors);
                      alert('Failed to add skill. Please check the form.');
                  }
              })
              .catch(error => {
                  console.error('Network error:', error);
                  alert('Network error occurred.');
              });
          });
      })
      .catch(error => {
        console.error('Error fetching new skill form:', error);
        alert('Error fetching new skill form.');
    });
});


  // Event delegation for remove_fields
  document.addEventListener('click', function(event) {
      if (event.target && event.target.classList.contains('remove_fields')) {
          event.preventDefault();
          event.target.closest('.nested-fields').remove();
      }
  });
});
