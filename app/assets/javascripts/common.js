document.addEventListener("DOMContentLoaded", function() {
  // Show loading spinner on submit
  const form = document.getElementById("weather-form");
  const loading = document.getElementById("loading");
  if (form) {
    form.addEventListener("submit", function() {
      if (loading) loading.classList.remove("hidden");
    });
  }

  // Clear history
  const clearBtn = document.getElementById("clear-history-btn");
  if (clearBtn) {
    clearBtn.addEventListener("click", function() {
      fetch("/weather/clear_history", {
        method: "DELETE",
        headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content, "Accept": "application/json" }
      })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          document.getElementById("history-container").innerHTML = `
            <div class="text-center py-8" id="empty-history">
              <div class="text-gray-400 text-4xl mb-3">📍</div>
              <p class="text-gray-500 text-sm">No recent searches yet</p>
              <p class="text-gray-400 text-xs mt-1">Your weather searches will appear here</p>
            </div>
          `;
        }
      });
    });
  }

  // Clear cache
  const clearCacheBtn = document.getElementById("clear-cache-btn");
  if (clearCacheBtn) {
    clearCacheBtn.addEventListener("click", function() {
      if (!confirm("Are you sure you want to clear all cached weather data?")) return;
      fetch("/weather/clear_cache", {
        method: "DELETE",
        headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content, "Accept": "application/json" }
      })
      .then(res => res.json())
      .then(data => {});
    });
  }
});

// Fill address helper
function fillAddress(address) {
  document.getElementById('address-input').value = address;
  document.getElementById('address-input').focus();
}


setTimeout(function() {
    document.querySelectorAll('[id^="flash-popup-"]').forEach(function(el) {
        el.style.display = 'none';
    });
}, 5000); // 4 seconds

