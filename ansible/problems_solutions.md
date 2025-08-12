# Проблемы и решения при настройке Ansible

## 1. Ошибка установки WSL на Windows
```bash
Не удалось запустить операцию, поскольку необходимая функция не установлена.
Код ошибки: Wsl/InstallDistro/Service/RegisterDistro/CreateVm/HCS/HCS_E_SERVICE_NOT_AVAILABLE
```

### Решение
1. Проверить включение виртуализации в BIOS/UEFI
2. Включить компоненты Windows в PowerShell (администратор):
```powershell
dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
dism /online /enable-feature /featurename:HypervisorPlatform /all /norestart
```

---

## 2. Ansible не видит инвентарь
```bash
[WARNING]: Unable to parse ... as an inventory source
[WARNING]: No inventory was parsed, only implicit localhost is available
```

### Решение
Правильный формат для INI-инвентаря (inventories/production/hosts.ini):
```ini
[home_servers]
localhost ansible_connection=local

[home_servers:vars]
ansible_user=<..>
```

---

## 3. Ошибка доступа к SSH-ключу
```bash
fatal: [localhost]: FAILED! => {"msg": "The 'file' lookup had an issue accessing the file '~/.ssh/id_ed25519.pub'"}
```

### Решение
Использовать абсолютные пути и отключать sudo для задач с SSH:
```yaml
- name: Add SSH public key
  become: false
  ansible.builtin.lineinfile:
    path: "/home/<..>/.ssh/authorized_keys"
    line: "{{ lookup('file', '/home/<...>/.ssh/ansible_key.pub') }}"
    state: present
```

---

## 4. Задачи выполняются от имени root
```yaml
TASK [Debug user directories] 
ok: [localhost] => {
    "msg": "User: <...>, Home: /root, Env Home: /root"
}
```

### Решение
Для задач, требующих пользовательского контекста:
1. Явно отключать sudo (`become: false`)
2. Использовать абсолютные пути
3. Для системных задач оставлять `become: true`

---

## 5. Роли не находятся
```bash
ERROR! the role 'base_setup' was not found
```

### Решение
1. Проверить структуру каталогов:
   ```
   roles/
   └── base_setup/
       ├── tasks/
       │   └── main.yml
   ```
2. Добавить в `ansible.cfg`:
   ```ini
   [defaults]
   roles_path = ./roles:~/.ansible/roles
   ```
3. Использовать абсолютный путь в плейбуке:
   ```yaml
   roles:
     - role: /home/<...>/ansible-home-automation/roles/base_setup
   ```

---

## 6. Ошибка при запуске задачи по имени
```bash
[ERROR]: No matching task "Ensure authorized_keys exists" found.
```

### Решение
1. Убедиться в точном совпадении имени (пробелы и регистр)
2. Использовать теги вместо имен задач:
   ```bash
   ansible-playbook site.yml --tags "ssh_setup"
   ```
3. В роли добавить теги:
   ```yaml
   - name: Ensure authorized_keys exists
     tags: ssh_setup
     file:
       path: ...
   ```

---

## 7. Неверный путь при использовании sudo
Задачи с `become: true` используют `/root/` вместо домашней директории пользователя.

### Решение
Использовать переменные Ansible:
```yaml
- name: Correct path with sudo
  become: true
  copy:
    src: file.txt
    dest: "{{ ansible_env.HOME }}/app/file.txt"
```

---

## Полезные команды для диагностики
```bash
# Проверка инвентаря
ansible-inventory --list --graph

# Запуск с детализацией
ansible-playbook site.yml -vvv

# Запуск конкретной задачи
ansible-playbook site.yml --tags "package_install"
```

---

> Среда реализации проекта:
> - Windows 11 (WSL2)
> - Ubuntu 24.04.3
> - Ansible 2.18.7
