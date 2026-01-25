"""
技能管理API
"""

import logging
import os
from pathlib import Path
from typing import List

from sanic import Blueprint, Request
from sanic_ext import openapi

from common.res_decorator import async_json_resp
from common.token_decorator import check_token
from model.schemas import BaseResponse, get_schema

logger = logging.getLogger(__name__)

bp = Blueprint("skillService", url_prefix="/system/skill")


def parse_skill_markdown(file_path: Path) -> dict:
    """解析 SKILL.md 文件，提取 front matter 中的 name 和 description"""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        # 解析 YAML front matter
        if content.startswith("---"):
            parts = content.split("---", 2)
            if len(parts) >= 3:
                front_matter = parts[1].strip()
                # 简单解析 YAML
                name = None
                description = None

                for line in front_matter.split("\n"):
                    line = line.strip()
                    if line.startswith("name:"):
                        name = line.split(":", 1)[1].strip().strip('"').strip("'")
                    elif line.startswith("description:"):
                        description = (
                            line.split(":", 1)[1].strip().strip('"').strip("'")
                        )

                return {
                    "name": name or file_path.parent.name,
                    "description": description or "",
                }
    except Exception as e:
        logger.error(f"解析技能文件失败 {file_path}: {e}")

    # 如果解析失败，返回默认值
    return {"name": file_path.parent.name, "description": ""}


@bp.get("/list")
@openapi.summary("获取技能列表")
@openapi.description("获取深度问数技能列表")
@openapi.tag("技能管理")
@openapi.response(
    200,
    {
        "application/json": {
            "schema": get_schema(BaseResponse),
        }
    },
    description="获取成功",
)
@check_token
@async_json_resp
async def get_skill_list(request: Request):
    """获取技能列表"""
    try:
        # 获取项目根目录
        current_file = Path(__file__)
        project_root = current_file.parent.parent
        skills_dir = project_root / "agent" / "deepagent" / "skills"

        skills = []

        if skills_dir.exists() and skills_dir.is_dir():
            # 遍历 skills 目录下的所有子目录
            for skill_dir in skills_dir.iterdir():
                if skill_dir.is_dir():
                    skill_file = skill_dir / "SKILL.md"
                    if skill_file.exists():
                        skill_info = parse_skill_markdown(skill_file)
                        skills.append(skill_info)

        # 按名称排序
        skills.sort(key=lambda x: x["name"])

        return skills
    except Exception as e:
        logger.error(f"获取技能列表失败: {e}", exc_info=True)
        raise
