<header class="topbar contribuyente-topbar">
    <div class="welcome-block">
        <h2>Bienvenido, ${sessionScope.usuario.persona.nombres} ${sessionScope.usuario.persona.apellidos}</h2>
        <p>Portal del Contribuyente</p>
    </div>

    <div class="topbar-right">
        <button class="notif-btn" type="button">
            <i class="fi fi-rr-bell"></i>
            <span class="notif-badge"></span>
        </button>

        <div class="topbar-user">
            <div class="topbar-avatar">
                ${sessionScope.usuario.persona.nombres.charAt(0)}
            </div>
            <div class="topbar-user-info">
                <h4>${sessionScope.usuario.persona.nombres} ${sessionScope.usuario.persona.apellidos}</h4>
                <p>Contribuyente</p>
            </div>
        </div>
    </div>
</header>
