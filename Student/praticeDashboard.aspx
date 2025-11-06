<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="praticeDashboard.aspx.cs" Inherits="WAPP_Assignment.Student.Pratice" MasterPageFile="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
  <link href="<%= ResolveUrl("~/Content/waplanding.css") %>" rel="stylesheet" />
  <style>
    .practice-main {
      margin-top: 80px;
      padding: 2rem 0;
      min-height: 100vh;
    }

    .practice-container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 2rem;
      display: grid;
      grid-template-columns: 1fr 350px;
      gap: 2rem;
    }

    .practice-content {
      width: 100%;
    }

    .chapter-section {
      background: var(--card);
      border: 1px solid var(--card-stroke);
      border-radius: 14px;
      margin-bottom: 1.5rem;
      overflow: hidden;
      transition: all 0.3s ease;
    }

    .chapter-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 1.5rem 2rem;
      cursor: pointer;
      transition: background 0.2s ease;
    }

    .chapter-header:hover {
      background: rgba(255, 255, 255, 0.03);
    }

    .chapter-info {
      display: flex;
      align-items: center;
      gap: 1rem;
      flex: 1;
    }

    .chapter-number {
      width: 50px;
      height: 50px;
      border-radius: 50%;
      background: rgba(102, 126, 234, 0.2);
      border: 2px solid rgba(102, 126, 234, 0.4);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.2rem;
      font-weight: 800;
      color: var(--text);
    }

    .chapter-details {
      flex: 1;
    }

    .chapter-title {
      font-size: 1.3rem;
      font-weight: 700;
      color: var(--text);
      margin-bottom: 0.25rem;
    }

    .chapter-desc {
      font-size: 0.9rem;
      color: var(--muted);
    }

    .chapter-toggle {
      padding: 0.5rem;
      background: transparent;
      border: none;
      color: var(--muted);
      cursor: pointer;
      font-size: 1.5rem;
      transition: transform 0.3s ease;
    }

    .chapter-toggle.open {
      transform: rotate(180deg);
    }

    .exercises-list {
      max-height: 0;
      overflow: hidden;
      transition: max-height 0.3s ease;
      background: rgba(0, 0, 0, 0.2);
    }

    .exercises-list.open {
      max-height: 1000px;
      padding: 1rem 2rem 1.5rem;
    }

    .exercise-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 1rem 1.5rem;
      background: var(--card);
      border: 1px solid var(--card-stroke);
      border-radius: 12px;
      margin-bottom: 0.75rem;
      transition: all 0.2s ease;
    }

    .exercise-item:hover {
      transform: translateY(-2px);
      border-color: rgba(102, 126, 234, 0.4);
    }

    .exercise-info {
      display: flex;
      align-items: center;
      gap: 1rem;
      flex: 1;
    }

    .exercise-label {
      font-size: 0.85rem;
      color: var(--muted);
      font-weight: 600;
      min-width: 80px;
    }

    .exercise-title {
      font-size: 1rem;
      font-weight: 600;
      color: var(--text);
    }

    .exercise-action {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .btn-start {
      background: var(--brand);
      color: #101212;
      border: none;
      padding: 0.65rem 1.5rem;
      border-radius: 10px;
      font-weight: 800;
      font-size: 0.9rem;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .btn-start:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(255, 210, 74, 0.3);
    }

    .btn-locked {
      background: rgba(255, 255, 255, 0.1);
      color: var(--muted);
      border: 1px solid var(--stroke);
      padding: 0.65rem 1.5rem;
      border-radius: 10px;
      font-weight: 800;
      font-size: 0.9rem;
      cursor: not-allowed;
      opacity: 0.6;
    }

    .sidebar-profile {
      position: sticky;
      top: 100px;
      align-self: flex-start;
    }

    .profile-card {
      background: var(--card);
      border: 1px solid var(--card-stroke);
      border-radius: 16px;
      padding: 2rem 1.5rem;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      margin-bottom: 1.25rem;
    }

    .profile-avatar {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      margin: 0 auto 1rem;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.5rem;
      border: 3px solid rgba(102, 126, 234, 0.2);
    }

    .profile-name {
      text-align: center;
      font-size: 1.2rem;
      font-weight: 700;
      margin-bottom: 0.5rem;
    }

    .profile-level {
      text-align: center;
      color: var(--muted);
      font-size: 0.9rem;
      margin-bottom: 1.5rem;
    }

    .progress-card {
      background: var(--card);
      border: 1px solid var(--card-stroke);
      border-radius: 16px;
      padding: 1.5rem;
    }

    .progress-title {
      font-size: 0.85rem;
      font-weight: 800;
      color: var(--text);
      margin-bottom: 1rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .progress-stat {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 1rem;
    }

    .stat-label {
      color: var(--muted);
      font-size: 0.9rem;
    }

    .stat-value {
      font-weight: 800;
      color: var(--brand);
      font-size: 1.1rem;
    }

    .progress-bar-container {
      height: 8px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 999px;
      overflow: hidden;
      margin-bottom: 0.5rem;
    }

    .progress-bar-fill {
      height: 100%;
      background: linear-gradient(90deg, #667eea 0%, var(--brand) 100%);
      border-radius: 999px;
      transition: width 0.3s ease;
    }

    .xp-stat {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 1rem;
      background: rgba(255, 210, 74, 0.1);
      border: 1px solid rgba(255, 210, 74, 0.2);
      border-radius: 12px;
      margin-top: 1rem;
    }

    .xp-icon {
      font-size: 1.5rem;
    }

    .xp-text {
      flex: 1;
    }

    .xp-label {
      font-size: 0.8rem;
      color: var(--muted);
    }

    .xp-value {
      font-size: 1.2rem;
      font-weight: 800;
      color: var(--brand);
    }

    .badge-unlocked {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.5rem 1rem;
      background: rgba(102, 255, 102, 0.1);
      border: 1px solid rgba(102, 255, 102, 0.2);
      border-radius: 20px;
      font-size: 0.85rem;
      color: #66ff66;
      font-weight: 600;
    }

    @media (max-width: 1200px) {
      .practice-container {
        grid-template-columns: 1fr;
      }

      .sidebar-profile {
        position: static;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 1.25rem;
      }
    }

    @media (max-width: 768px) {
      .exercise-item {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
      }

      .exercise-action {
        width: 100%;
      }

      .btn-start, .btn-locked {
        width: 100%;
      }
    }
  </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <main class="practice-main">
    <div class="practice-container">
      <!-- Main Content -->
      <div class="practice-content">
        <h1 style="font-size: 2rem; font-weight: 800; margin-bottom: 2rem;">Lorem Ipsum Dolor</h1>

        <!-- Chapter 1: Elements -->
        <div class="chapter-section">
          <div class="chapter-header">
            <div class="chapter-info">
              <div class="chapter-number">1</div>
              <div class="chapter-details">
                <h2 class="chapter-title">Lorem Ipsum</h2>
                <p class="chapter-desc">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.</p>
              </div>
            </div>
            <button type="button" class="chapter-toggle">▼</button>
          </div>
          <div class="exercises-list">
            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Lorem 1</span>
                <h3 class="exercise-title">Dolor Sit Amet</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-start" onclick="window.location.href='<%= ResolveUrl("~/Student/Exercise.aspx?id=1") %>'">Start</button>
              </div>
            </div>

            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Lorem 2</span>
                <h3 class="exercise-title">Consectetur</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-locked">???</button>
              </div>
            </div>

            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Lorem 3</span>
                <h3 class="exercise-title">Adipiscing</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-locked">???</button>
              </div>
            </div>

            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Lorem 4</span>
                <h3 class="exercise-title">Tempor Incididunt</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-locked">???</button>
              </div>
            </div>

            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Lorem 5</span>
                <h3 class="exercise-title">Ut Labore</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-locked">???</button>
              </div>
            </div>

            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Lorem 6</span>
                <h3 class="exercise-title">Dolore Magna</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-locked">???</button>
              </div>
            </div>

            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Lorem 7</span>
                <h3 class="exercise-title">Aliqua Enim</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-locked">???</button>
              </div>
            </div>

            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Bonus Lorem</span>
                <h3 class="exercise-title">Lorem ipsum dolor sit amet</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-locked">???</button>
              </div>
            </div>
          </div>
        </div>

        <div class="chapter-section">
          <div class="chapter-header">
            <div class="chapter-info">
              <div class="chapter-number">2</div>
              <div class="chapter-details">
                <h2 class="chapter-title">Sed Do Eiusmod</h2>
                <p class="chapter-desc">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi.</p>
              </div>
            </div>
            <button type="button" class="chapter-toggle">▼</button>
          </div>
          <div class="exercises-list">
            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Lorem 1</span>
                <h3 class="exercise-title">Commodo Consequat</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-locked">???</button>
              </div>
            </div>

            <div class="exercise-item">
              <div class="exercise-info">
                <span class="exercise-label">Lorem 2</span>
                <h3 class="exercise-title">Duis Aute Irure</h3>
              </div>
              <div class="exercise-action">
                <button type="button" class="btn-locked">???</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <aside class="sidebar-profile">
        <div class="profile-card">
          <div class="profile-avatar">👤</div>
          <h3 class="profile-name">Lorem Ipsum</h3>
          <p class="profile-level">Dolor Sit 1</p>
        </div>

        <div class="progress-card">
          <h3 class="progress-title">Lorem Progress</h3>
          
          <div class="progress-stat">
            <span class="stat-label">Ipsum Dolor</span>
            <span class="stat-value">0 / 26</span>
          </div>
          <div class="progress-bar-container">
            <div class="progress-bar-fill" style="width: 0%"></div>
          </div>

          <div class="progress-stat" style="margin-top: 1rem;">
            <span class="stat-label">Consectetur Adipiscing</span>
            <span class="stat-value">0 / 1</span>
          </div>
          <div class="progress-bar-container">
            <div class="progress-bar-fill" style="width: 0%"></div>
          </div>

          <div class="xp-stat">
            <span class="xp-icon">⭐</span>
            <div class="xp-text">
              <div class="xp-label">Lorem Ipsum</div>
              <div class="xp-value">0 / 430</div>
            </div>
          </div>
        </div>
      </aside>
    </div>
  </main>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.chapter-header').forEach(function (header) {
            header.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                const section = header.parentElement;
                const list = section.querySelector('.exercises-list');
                const toggle = section.querySelector('.chapter-toggle');

                const open = list.classList.toggle('open');
                toggle.classList.toggle('open', open);
                toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
            });
        });
    });
</script>

</asp:Content>