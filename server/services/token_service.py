from datetime import datetime
from sqlalchemy.orm import Session
from ..models.token import Token
from ..models.user import User
from ..utils.security import hash_token

class TokenService:
    def __init__(self, db_session: Session):
        self.db = db_session

    def create_token(self, user_id: int, token_data: dict) -> Token:
        """Crea un nuevo token para un usuario"""
        # Validar que el usuario existe
        user = self.db.query(User).filter(User.id == user_id).first()
        if not user:
            raise ValueError("Usuario no encontrado")

        # Crear el token
        token = Token(
            user_id=user_id,
            name=token_data.get('name'),
            value=hash_token(token_data.get('value')),
            description=token_data.get('description'),
            created_at=datetime.utcnow(),
            expires_at=token_data.get('expires_at')
        )

        self.db.add(token)
        self.db.commit()
        self.db.refresh(token)
        return token

    def get_user_tokens(self, user_id: int) -> list:
        """Obtiene todos los tokens de un usuario"""
        return self.db.query(Token).filter(Token.user_id == user_id).all()

    def get_token(self, token_id: int, user_id: int) -> Token:
        """Obtiene un token específico de un usuario"""
        token = self.db.query(Token).filter(
            Token.id == token_id,
            Token.user_id == user_id
        ).first()
        
        if not token:
            raise ValueError("Token no encontrado")
        return token

    def delete_token(self, token_id: int, user_id: int) -> bool:
        """Elimina un token específico"""
        token = self.get_token(token_id, user_id)
        if token:
            self.db.delete(token)
            self.db.commit()
            return True
        return False

    def update_token(self, token_id: int, user_id: int, token_data: dict) -> Token:
        """Actualiza un token existente"""
        token = self.get_token(token_id, user_id)
        
        if 'name' in token_data:
            token.name = token_data['name']
        if 'description' in token_data:
            token.description = token_data['description']
        if 'expires_at' in token_data:
            token.expires_at = token_data['expires_at']
        
        token.updated_at = datetime.utcnow()
        self.db.commit()
        self.db.refresh(token)
        return token 